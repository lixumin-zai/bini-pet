//
//  Sence.swift
//  bini-pet
//
//  Created by lixumin on 2025/1/21.
//

import SwiftUI


struct Sence: View {
    @State private var tapLocation: CGPoint = .zero
    
    @State private var petPosition: CGPoint = .zero // 用于存储 Pet() 的位置
    @State private var petSize: CGSize = .zero // 用于存储 Pet() 的尺寸
    
    @State private var isMovingRight: Bool = true // 控制移动方向
    @State private var isMovingUp: Bool = true // 控制移动方向
    private let HorizontalStepSize: CGFloat = 15 // 每次移动的步长
    private let VerticalStepSize: CGFloat = 7 // 每次移动的步长
    
    @State private var petStatus: Status = .standing
    @State private var petWalkingStatus: WalkingStatus = .Right
    
    var body: some View {
        VStack {
            Pet(status: $petStatus, walkingStatus: $petWalkingStatus, isMovingRight: $isMovingRight)
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
                    startStepMovement()
                }
        }
        .frame(width: 200, height: 200)
        .background(Color.gray)
        .contentShape(Rectangle()) // 确保整个区域都可以响应点击
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    // 获取手指当前位置
                    self.tapLocation = value.location
                    self.petPosition = CGPoint(x: value.location.x - 100, y: value.location.y - 100)
                }
        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(Color.blue, lineWidth: 2) // 设置边框颜色和宽度
//        )
    }
    
    func startStepMovement() {
        Timer.scheduledTimer(withTimeInterval: 0.52, repeats: true) { timer in
//            print(petStatus)
            if Int.random(in: 0...10) > 2 {
                petStatus = .walking
                startWalk()
            } else {
                petStatus = .standing
                stopWalk()
            }
        }
    }
    
    func startWalk() {
        let horizontalStep = isMovingRight ? HorizontalStepSize : -HorizontalStepSize
        let verticalStep = isMovingUp ? VerticalStepSize: -VerticalStepSize
        print(petPosition.x, petPosition.y)
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
            if petPosition.x < -70 {
                isMovingRight = true
            }
            if petPosition.y > 70 {
                isMovingUp = false
            }
            if petPosition.y < -70 {
                isMovingUp = true
            }
        }
    }
    
    func stopWalk() {
        
    }
}
