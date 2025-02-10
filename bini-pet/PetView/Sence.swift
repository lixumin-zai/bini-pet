//
//  Sence.swift
//  bini-pet
//
//  Created by lixumin on 2025/1/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct Sence: View {
    @State private var tapLocation: CGPoint = .zero
    
    @State private var containerSize: CGPoint = .zero
    
    // 宠物信息
    @State private var petOriginPosition: CGPoint = CGPoint(x: 0.25, y: 0.75) // 位置百分比
    @State private var petPositionOffset: CGPoint = .zero // 用于存储 Pet 偏移 的位置
    @State private var petSize: CGSize = .zero // 用于存储 Pet 的尺寸
    
    @State private var isWalk: Bool = false
    @State private var isMovingRight: Bool = true // 控制水平移动方向
    @State private var isMovingUp: Bool = true // 控制垂直移动方向
    @State private var HorizontalStepSize: CGFloat = 7 // 每次移动的步长
    @State private var VerticalStepSize: CGFloat = 7 // 每次移动的步长
    
    @State private var petStatus: Status = .standing  // 宠物的状态
    @State private var pettingTimes: Int = 0  // 宠物的抚摸步
    
    @State private var hunger: Int = 50  // 饱腹值
    @State private var bowlPosition: CGPoint = CGPoint(x: 40, y: 140)
    
    var body: some View {
        ZStack {
            GeometryReader { container in
                ZStack {
                    // 背景（占满容器宽度的 80%，高度自适应）
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
                    if tapLocation != .zero {
                        Circle()
                            .fill(Color.green)
                            .frame(
                                width: 6, // 标记点大小为宽度的 3%
                                height: 6
                            )
                            .position(tapLocation)
                    }
                    
                    // 宠物组件（宽高占容器 20%）
                    Pet(status: $petStatus, isMovingRight: $isMovingRight, pettingTimes: $pettingTimes)
                        .frame(
                            width: container.size.width * 0.2,
                            height: container.size.width * 0.2
                        )
                        .position(
                            x: container.size.width * petOriginPosition.x + petPositionOffset.x, // 居中 + 动态偏移
                            y: container.size.height * petOriginPosition.y + petPositionOffset.y
                        )
                        .onAppear {
                            containerSize.x = container.size.width
                            containerSize.y = container.size.height
                            start()
                        }
                }
                .frame(
                    width: container.size.width * 0.8, // 主内容区域占屏幕宽度的 80%
                    height: container.size.width * 0.8 // 保持宽高一致
                )
                .position(
                    x: container.size.width / 2, // 居中
                    y: container.size.height / 2
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // 计算点击位置相对于容器的比例坐标
                            let tapX = value.location.x
                            let tapY = value.location.y
                            self.tapLocation = CGPoint(x: tapX, y: tapY)
                            
                            // 宠物当前位置（中心点）
                            let petCenterX = container.size.width * petOriginPosition.x + petPositionOffset.x
                            let petCenterY = container.size.height * petOriginPosition.y + petPositionOffset.y
                            
                            // 计算移动方向和步长（基于容器宽度动态调整）
                            let deltaX = tapX - petCenterX
                            let deltaY = tapY - petCenterY
                            let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
                            
                            // 步长按容器比例缩放（基础步长为屏幕宽度的 2%）
                            let baseStep = container.size.width * 0.05
                            self.HorizontalStepSize = (deltaX / distance) * baseStep
                            self.VerticalStepSize = (deltaY / distance) * baseStep
                            
                            petStatus = .walking
                        }
                )
                
            }
            
            
            // 文字始终居中（独立于动态布局）
            Text("123")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .background(Color.black)
    }
    
    func startWalk() {
        petStatus = .walking
        if petPositionOffset.x > 70 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.47) {
                petStatus = .standing
            }
            isMovingRight = false
        }
        if petPositionOffset.x < -32.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.47) {
                petStatus = .standing
            }
            isMovingRight = true
        }
        if petPositionOffset.y > 32.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.47) {
                petStatus = .standing
            }
            isMovingUp = false
        }
        if petPositionOffset.y < -32.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.47) {
                petStatus = .standing
            }
            isMovingUp = true
        }
        let horizontalStep = isMovingRight ? HorizontalStepSize : -HorizontalStepSize
        let verticalStep = isMovingUp ? VerticalStepSize: -VerticalStepSize
//        print(petPosition.x, petPosition.y)
        withAnimation(.linear(duration: 0.5)) {
            petPositionOffset.x += horizontalStep
            petPositionOffset.y += verticalStep
        }
        let petCenter = CGPoint(x: self.petPositionOffset.x + containerSize.x * self.petOriginPosition.x,
                                y: self.petPositionOffset.y + containerSize.y * self.petOriginPosition.y)

        // 计算 tapLocation 和 petCenter 之间的距离
        let deltaX = self.tapLocation.x - petCenter.x
        let deltaY = self.tapLocation.y - petCenter.y
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        
        // 如果距离小于某个阈值（例如 1），则认为已经到达目标位置
        if distance < 3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.47) {
                petStatus = .standing
            }
        }
        print(self.tapLocation)
        
    }
    
    func start() {
        Timer.scheduledTimer(withTimeInterval: 0.52, repeats: true) { timer in
            scheduleTaskAtHalfHour() // 判断没半个小时做的事情
            
            if petStatus == .walking {
                startWalk()
            } else if petStatus == .toEat {
                toEat()
                

            } else if petStatus == .eating {
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {  // 持续1分钟
                //                    petStatus = .standing
                //                    print(petStatus)
                //                }
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
    
    func randomStartWalk() {
        let horizontalStep = isMovingRight ? HorizontalStepSize : -HorizontalStepSize
        let verticalStep = isMovingUp ? VerticalStepSize: -VerticalStepSize
        withAnimation(.linear(duration: 0.5)) {
            petPositionOffset.x += horizontalStep
            petPositionOffset.y += verticalStep
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.47) {
            if Int.random(in: 0...10) > 8 {
                isMovingRight.toggle()
            }
            if Int.random(in: 0...10) > 8 {
                isMovingUp.toggle()
            }
            if petPositionOffset.x > 70 {
                isMovingRight = false
            }
            if petPositionOffset.x < -32.0 {
                isMovingRight = true
            }
            if petPositionOffset.y > 32.0 {
                isMovingUp = false
            }
            if petPositionOffset.y < -32.0 {
                isMovingUp = true
            }
        }
    }
    
    func toEat() {
        
        let horizontalStep = isMovingRight ? HorizontalStepSize : -HorizontalStepSize
        let verticalStep = isMovingUp ? VerticalStepSize: -VerticalStepSize
//        print(petPosition.x, petPosition.y)
        withAnimation(.linear(duration: 0.5)) {
            petPositionOffset.x += horizontalStep
            petPositionOffset.y += verticalStep
        }
        let petCenter = CGPoint(x: self.petPositionOffset.x + containerSize.x * self.petOriginPosition.x,
                                y: self.petPositionOffset.y + containerSize.y * self.petOriginPosition.y)

        // 计算 tapLocation 和 petCenter 之间的距离
        let deltaX = bowlPosition.x - petCenter.x
        let deltaY = bowlPosition.y - petCenter.y - 10
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        
        // 如果距离小于某个阈值（例如 1），则认为已经到达目标位置
        if distance < 5 {
            petStatus = .eating
        }
        print(bowlPosition)
        print(petPositionOffset.x, petPositionOffset.y)
        
    }
    
    func stopWalk() {
    }
    
    func scheduleTaskAtHalfHour() {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute], from: now)
        
        if let minute = components.minute {
            if minute == 58 || minute == 30 {
                // 计算 pet 的当前位置
                if petStatus != .toEat {
                    let petCenter = CGPoint(x: self.petPositionOffset.x + containerSize.x * self.petOriginPosition.x,
                                            y: self.petPositionOffset.y + containerSize.y * self.petOriginPosition.y)
                    
                    // 计算 tapLocation 和 petCenter 之间的向量
                    let deltaX = self.bowlPosition.x - petCenter.x
                    let deltaY = self.bowlPosition.y - petCenter.y
                    
                    // 计算距离
                    let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
                    
                    
                    // 更新移动方向
                    self.isMovingRight = deltaX > 0
                    self.isMovingUp = deltaY > 0  // 注意：Y轴方向在屏幕上是从上到下增加的
                    
                    // 根据距离调整步长（可以根据需要调整步长的计算方式）
                    self.HorizontalStepSize = abs(deltaX) / distance * 7
                    self.VerticalStepSize = abs(deltaY) / distance * 7
                    petStatus = .toEat
                    
                }
            }
        }
    }
}
