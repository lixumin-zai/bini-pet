//
//  Pet.swift
//  bini-pet
//
//  Created by lixumin on 2025/1/21.
//
// "https://public-1259491855.cos.ap-beijing.myqcloud.com/brown_walk_fast_8fps.gif"

import SwiftUI
import SDWebImageSwiftUI


// 定义状态枚举
enum PetStatus {
    case walking
    case standing
    case lyingDown
    case eating
    case toEat
    case petting
    case randomWalking
}

// 方向枚举
enum PetWalkingDirection {
    case UpLeft
    case BottomLeft
    case UpRight
    case BottomRight
    case Up
    case Bottom
    case Right
    case Left
}


// 定义 Pet 类
class Pet: Identifiable {
    let id = UUID()
    var name: String
    var images_url: String
    var status: PetStatus = .standing // 默认状态为 standing
    var walkingStatus: PetWalkingDirection? // 行走状态，默认为 nil
    
    init(name: String, images_url: String) {
        self.name = name
        self.images_url = images_url
    }
    
    // 方法：更新状态
    func updateStatus(to newStatus: PetStatus) {
        self.status = newStatus
        print("\(name) 的状态已更新为: \(newStatus)")
    }
    
    // 方法：更新方向状态
    func updateWalkingStatus(to newPetWalkingDirection: PetWalkingDirection?) {
        self.walkingStatus = newPetWalkingDirection
        if let walkingStatus = newPetWalkingDirection {
            print("\(name) 的行走状态已更新为: \(walkingStatus)")
        } else {
            print("\(name) 的行走状态已清除")
        }
    }
}


struct PetView: View {
    
    // 定义传入的参数
    @Binding var status: PetStatus    // 宠物状态
    @Binding var isMovingRight: Bool  // 控制移动左右方向
    @Binding var pettingTimes: Int    // 宠物的抚摸时间
    @Binding var petSize: CGSize
    @Binding var containerSize: CGPoint
    
    @State private var offsetX: CGFloat = 0    // 偏移量
    @State private var offsetY: CGFloat = 0    // 偏移量
    @State private var isMovingUp: Bool = true // 控制移动上下方向
    @State private var imageUrl: URL? = Bundle.main.url(forResource: "brown_idle_8fps", withExtension: "gif")
    private let HorizontalStepSize: CGFloat = 7  // 每次移动的步长
    private let VerticalStepSize: CGFloat = 7    // 每次移动的步长
    
    var body: some View {
        WebImage(url: imageUrl)
            .resizable()
            .scaledToFit()
            .frame(width: containerSize.x*petSize.width, height: containerSize.y*petSize.height)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 2) // 设置边框颜色和宽度
            )
            .scaleEffect(x: isMovingRight ? 1 : -1, y: 1) // 水平翻转
            .offset(x: offsetX, y: offsetY)
            .contentShape(Circle().size(width: 16, height: 16).offset(x: 12, y: 12))  // 限制点击区域为 20x20

            .onChange(of: status) { newValue in
                imageUrl = getImageUrl() // 当 isStop 变化时更新图片 URL
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                    // 获取手指当前位置
                        pettingTimes = 5
                        status = .petting
                    }
            )
    }
    
    // 动态选择图片 URL
    func getImageUrl() -> URL? {
        if status == .standing {
            return Bundle.main.url(forResource: "brown_idle_8fps", withExtension: "gif")
        } else if status == .eating {
            return Bundle.main.url(forResource: "brown_idle_8fps", withExtension: "gif")
        } else if status == .toEat {
            return Bundle.main.url(forResource: "brown_walk_fast_8fps", withExtension: "gif")
        } else if status == .petting {
            return Bundle.main.url(forResource: "brown_petting_8fps", withExtension: "gif")
        } else {
            return Bundle.main.url(forResource: "brown_walk_fast_8fps", withExtension: "gif")
        }
    }
}
