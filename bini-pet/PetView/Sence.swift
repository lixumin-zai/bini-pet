//
//  Sence.swift
//  bini-pet
//
//  Created by lixumin on 2025/1/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct Sence: View {
    @State private var touchLocation: CGPoint = .zero  // 点击位置
    
    @State private var containerSize: CGPoint = .zero  // 场景的宽高
    
    // 宠物信息
    @State private var petOriginPosition: CGPoint = CGPoint(x: 0.25, y: 0.75)  // 位置百分比
    @State private var petSize: CGSize = CGSize(width: 0.2, height: 0.2)  // 用于存储 Pet 的尺寸
    @State private var isPlay: Bool = false
    
    @State private var isMovingRight: Bool = true        // 控制水平移动方向
    @State private var isMovingUp: Bool = true           // 控制垂直移动方向
    @State private var HorizontalStepSize: CGFloat = 0.05   // 每次移动的步长
    @State private var VerticalStepSize: CGFloat = 0.05     // 每次移动的步长
    
    @State private var petStatus: PetStatus = .standing  // 宠物的状态
    @State private var pettingTimes: Int = 0             // 宠物的抚摸时间步长
    
    @State private var hunger: Int = 50                  // 饱腹值
    
    @State private var bowlPosition: CGPoint = CGPoint(x: 0.1, y: 0.55)  //垃圾桶位置
    
    var body: some View {
        ZStack {
            GeometryReader { container in
                ZStack {
                    // 背景
                    WebImage(url: Bundle.main.url(forResource: "room", withExtension: "png"))
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fill) // 填充屏幕（可能裁剪图片）
                        .frame(
                            width: container.size.width * 1, // 屏幕宽度的 80%
                            height: container.size.height * 1 // 保持宽高比 1:1（根据实际需求调整）
                        )
                    
                    // 窗户背景（占容器宽度的 30%，高度自适应）
                    WebImage(url: Bundle.main.url(forResource: "outside_base", withExtension: "jpeg"))
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: container.size.width * 0.3, // 容器宽度的 30%
                            height: container.size.width * 0.3 // 保持正方形
                        )
                        .position(
                            x: container.size.width * 0.4, // 水平位置 40%
                            y: container.size.height * 0.3 // 垂直位置 30%
                        )
                    // 点击标记点
                    if touchLocation != .zero && (0.0...0.75).contains(touchLocation.x/container.size.width) && (0.5...1.0).contains(touchLocation.y/container.size.height) {
                        Circle()
                            .fill(Color.green)
                            .frame(
                                width: 6, // 标记点大小为宽度的 3%
                                height: 6
                            )
                            .position(touchLocation)
                        }
                    // 宠物组件（宽高占容器 20%）
                    PetView(status: $petStatus,
                            isMovingRight: $isMovingRight,
                            pettingTimes: $pettingTimes,
                            petSize: $petSize,
                            containerSize: $containerSize)
                        .frame(
                            width: container.size.width * 0.2,
                            height: container.size.width * 0.2
                        )
                        .position(
                            x: container.size.width * petOriginPosition.x, // 居中 + 动态偏移
                            y: container.size.height * petOriginPosition.y
                        )
                        .onAppear {
                            containerSize.x = container.size.width
                            containerSize.y = container.size.height
                            start()
                        }
                }
                .position(
                    x: container.size.width / 2, // 居中
                    y: container.size.height / 2
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // 计算点击位置相对于容器的比例坐标
                            self.touchLocation = CGPoint(x: value.location.x, y: value.location.y)
                            if touchLocation != .zero && (0.0...0.75).contains(touchLocation.x/container.size.width) && (0.5...1.0).contains(touchLocation.y/container.size.height) {
                                isPlay = true
                            } else {
                                isPlay = false
                            }
                            
                            if isPlay{
                                petStatus = .walking
                            } else {
                                petStatus = .standing
                            }
                        }
                )
            }
            .scaledToFit()
            .aspectRatio(contentMode: .fill)
            
            Text("饱腹值")
                .font(.system(size: containerSize.x * 0.06, weight: .bold))
                .position(x: containerSize.x * 0.1, y: -containerSize.y * 0.05)
        }
        .background(Color.black)
    }
    
    
    func start() {
        Timer.scheduledTimer(withTimeInterval: 0.52, repeats: true) { timer in
             // 判断没半个小时做的事情
            scheduleTaskAtHalfHour()
            if petStatus == .walking {
                startWalk()
            } else if petStatus == .toEat {
                toEat()
            } else if petStatus == .eating {
                let calendar = Calendar.current
                let now = Date()
                let components = calendar.dateComponents([.minute], from: now)
                
                if let minute = components.minute {
                    if minute != 58 || minute != 36 {
                        petStatus = .standing
                    }
                }
            } else if petStatus == .petting {
                pettingTimes -= 1
                if pettingTimes == 0 {
                    petStatus = .standing
                }
            } else if Int.random(in: 0...10) > 8 {
                petStatus = .randomWalking
                randomStartWalk()
            } else {
                petStatus = .standing
                stopWalk()
            }
        }
    }
    
    
    func startWalk() {
        // 宠物当前位置（中心点）
        let deltaX = self.touchLocation.x - self.containerSize.x * self.petOriginPosition.x
        let deltaY = self.touchLocation.y - self.containerSize.y * self.petOriginPosition.y
        
        self.isMovingRight = deltaX > 0
        self.isMovingUp = deltaY > 0
        
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        
        // 步长按容器比例缩放（基础步长为屏幕宽度的 2%）
        let baseStep = 0.05
        self.HorizontalStepSize = abs(deltaX) / distance * baseStep
        self.VerticalStepSize = abs(deltaY) / distance * baseStep
        
        let horizontalStep = self.isMovingRight ? self.HorizontalStepSize : -self.HorizontalStepSize
        let verticalStep = self.isMovingUp ? self.VerticalStepSize: -self.VerticalStepSize
        
        let newX = self.petOriginPosition.x + horizontalStep
        // 确保 newX 在 0 到 0.75 之间
        let clampedX = min(max(newX, 0.1), 0.75)
        
        let newY = self.petOriginPosition.y + verticalStep
        // 确保 newX 在 0 到 0.75 之间
        let clampedY = min(max(newY, 0.5), 0.9)
        withAnimation(.linear(duration: 0.5)) {
            self.petOriginPosition.x = clampedX
            self.petOriginPosition.y = clampedY
        }
        
        print(distance)
        // 如果距离小于某个阈值（例如 1），则认为已经到达目标位置
        if distance < self.containerSize.x*0.06 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.47) {
                petStatus = .standing
                touchLocation = .zero
            }
        }
    }
    
    
    func randomStartWalk() {
        let horizontalStep = isMovingRight ? HorizontalStepSize : -HorizontalStepSize
        let verticalStep = isMovingUp ? VerticalStepSize: -VerticalStepSize
        
        let newX = petOriginPosition.x + horizontalStep
        // 确保 newX 在 0 到 0.75 之间
        let clampedX = min(max(newX, 0.1), 0.75)
        
        let newY = petOriginPosition.y + verticalStep
        // 确保 newX 在 0 到 0.75 之间
        let clampedY = min(max(newY, 0.5), 0.9)
        withAnimation(.linear(duration: 0.5)) {
            petOriginPosition.x = clampedX
            petOriginPosition.y = clampedY
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.47) {
            if Int.random(in: 0...10) > 8 {
                isMovingRight.toggle()
            }
            if Int.random(in: 0...10) > 8 {
                isMovingUp.toggle()
            }
        }
    }
    
    func toEat() {
        let horizontalStep = isMovingRight ? HorizontalStepSize : -HorizontalStepSize
        let verticalStep = isMovingUp ? VerticalStepSize: -VerticalStepSize
        
        let newX = petOriginPosition.x + horizontalStep
        // 确保 newX 在 0 到 0.75 之间
        let clampedX = min(max(newX, 0.1), 0.75)
        
        let newY = petOriginPosition.y + verticalStep
        // 确保 newX 在 0 到 0.75 之间
        let clampedY = min(max(newY, 0.5), 0.9)
        
        print(clampedX, clampedY)
        withAnimation(.linear(duration: 0.5)) {
            petOriginPosition.x = clampedX
            petOriginPosition.y = clampedY
        }

        // 计算 touchLocation 和 petCenter 之间的距离
        let deltaX = bowlPosition.x - self.petOriginPosition.x
        let deltaY = bowlPosition.y - self.petOriginPosition.y
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        
        // 如果距离小于某个阈值（例如 1），则认为已经到达目标位置
        print(distance)
        if distance < 0.025 {
            petStatus = .eating
        }
        print(bowlPosition)
        print(petOriginPosition)
        print(petStatus)
    }
    
    func stopWalk() {
    }
    
    func scheduleTaskAtHalfHour() {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute], from: now)
        
        if let minute = components.minute {
            if minute == 58 || minute == 52 {
                // 计算 pet 的当前位置
                if petStatus != .toEat {
           
                    // 计算 touchLocation 和 petCenter 之间的向量
                    let deltaX = self.bowlPosition.x - self.petOriginPosition.x
                    let deltaY = self.bowlPosition.y - self.petOriginPosition.y
                    
                    // 计算距离
                    let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
                    
                    // 更新移动方向
                    self.isMovingRight = deltaX > 0
                    self.isMovingUp = deltaY > 0  // 注意：Y轴方向在屏幕上是从上到下增加的
                    
                    // 根据距离调整步长（可以根据需要调整步长的计算方式）
                    self.HorizontalStepSize = abs(deltaX) / distance * 0.05
                    self.VerticalStepSize = abs(deltaY) / distance * 0.05
                    petStatus = .toEat
                }
            }
        }
    }
}
