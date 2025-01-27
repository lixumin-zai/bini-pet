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
    
    // 宠物信息
    @State private var petOriginPosition: CGPoint = CGPoint(x: 50, y: 150)
    @State private var petPosition: CGPoint = .zero // 用于存储 Pet 偏移 的位置
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
            
            
            ZStack {
                // 背景
                WebImage(url: Bundle.main.url(forResource: "room", withExtension: "png"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                // 窗户背景
                WebImage(url: Bundle.main.url(forResource: "outside_base", withExtension: "jpeg"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .position(x: 80, y: 60)
                if tapLocation != .zero {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 6, height: 6)
                        .position(x: tapLocation.x, y: tapLocation.y)
                        .drawingGroup() // 渲染为位图，避免抗锯齿
                }
                Pet(status: $petStatus, isMovingRight: $isMovingRight, pettingTimes: $pettingTimes)
                    .position(x: petOriginPosition.x, y: petOriginPosition.y)
                    .offset(x: petPosition.x, y: petPosition.y) // 根据 petPosition 移动 Pet()
                    .background(GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                // 获取 Pet() 的尺寸
                                self.petSize = geometry.size
                                print(geometry.size)
                            }
                    })
                    .onAppear {
                        //                    petStatus = .standing
                        //                    stopWalk()
                        startStepMovement()
                    }
                
            }
            .frame(width: 200, height: 200)
            .clipped()
            .contentShape(Rectangle()) // 确保整个区域都可以响应点击
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // 获取手指当前位置
                        self.tapLocation = value.location
                        
                        // 计算 pet 的当前位置
                        let petCenter = CGPoint(x: self.petPosition.x + self.petOriginPosition.x,
                                                y: self.petPosition.y + self.petOriginPosition.y)
                        
                        // 计算 tapLocation 和 petCenter 之间的向量
                        let deltaX = self.tapLocation.x - petCenter.x
                        let deltaY = self.tapLocation.y - petCenter.y
                        
                        // 计算距离
                        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
                        
                        
                        // 更新移动方向
                        self.isMovingRight = deltaX > 0
                        self.isMovingUp = deltaY > 0  // 注意：Y轴方向在屏幕上是从上到下增加的
                        
                        // 根据距离调整步长（可以根据需要调整步长的计算方式）
                        self.HorizontalStepSize = abs(deltaX) / distance * 7
                        self.VerticalStepSize = abs(deltaY) / distance * 7
                        
                        petStatus = .walking
                    }
                )
            Text("123")
                .font(.system(size: 24, weight: .bold)) // 设置字体大小和粗体
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // 居中
        }
        .background(Color.black)
    }
    
    func startWalk() {
        petStatus = .walking
        if petPosition.x > 70 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.47) {
                petStatus = .standing
            }
            isMovingRight = false
        }
        if petPosition.x < -32.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.47) {
                petStatus = .standing
            }
            isMovingRight = true
        }
        if petPosition.y > 32.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.47) {
                petStatus = .standing
            }
            isMovingUp = false
        }
        if petPosition.y < -32.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.47) {
                petStatus = .standing
            }
            isMovingUp = true
        }
        let horizontalStep = isMovingRight ? HorizontalStepSize : -HorizontalStepSize
        let verticalStep = isMovingUp ? VerticalStepSize: -VerticalStepSize
//        print(petPosition.x, petPosition.y)
        withAnimation(.linear(duration: 0.5)) {
            petPosition.x += horizontalStep
            petPosition.y += verticalStep
        }
        let petCenter = CGPoint(x: self.petPosition.x + self.petOriginPosition.x,
                                y: self.petPosition.y + self.petOriginPosition.y)

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
    
    func startStepMovement() {
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
            petPosition.x += horizontalStep
            petPosition.y += verticalStep
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.47) {
            if Int.random(in: 0...10) > 8 {
                isMovingRight.toggle()
            }
            if Int.random(in: 0...10) > 8 {
                isMovingUp.toggle()
            }
            if petPosition.x > 70 {
                isMovingRight = false
            }
            if petPosition.x < -32.0 {
                isMovingRight = true
            }
            if petPosition.y > 32.0 {
                isMovingUp = false
            }
            if petPosition.y < -32.0 {
                isMovingUp = true
            }
        }
    }
    
    func toEat() {
        
        let horizontalStep = isMovingRight ? HorizontalStepSize : -HorizontalStepSize
        let verticalStep = isMovingUp ? VerticalStepSize: -VerticalStepSize
//        print(petPosition.x, petPosition.y)
        withAnimation(.linear(duration: 0.5)) {
            petPosition.x += horizontalStep
            petPosition.y += verticalStep
        }
        let petCenter = CGPoint(x: self.petPosition.x + self.petOriginPosition.x,
                                y: self.petPosition.y + self.petOriginPosition.y)

        // 计算 tapLocation 和 petCenter 之间的距离
        let deltaX = bowlPosition.x - petCenter.x
        let deltaY = bowlPosition.y - petCenter.y - 10
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        
        // 如果距离小于某个阈值（例如 1），则认为已经到达目标位置
        if distance < 5 {
            petStatus = .eating
        }
        print(bowlPosition)
        print(petPosition.x, petPosition.y)
        
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
                    let petCenter = CGPoint(x: self.petPosition.x + self.petOriginPosition.x,
                                            y: self.petPosition.y + self.petOriginPosition.y)
                    
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
