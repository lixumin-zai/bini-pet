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
enum Status {
    case walking
    case standing
    case lyingDown
    case eating
    case toEat
    case petting
    case randomWalking
}

enum WalkingStatus {
    case UpLeft
    case BottomLeft
    case UpRight
    case BottomRight
    case Up
    case Bottom
    case Right
    case Left
}

struct Pet: View {
    
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    
    @Binding var status: Status
//    @Binding var walkingStatus: WalkingStatus
    
    @Binding var isMovingRight: Bool
    @State private var isMovingUp: Bool = true // 控制移动方向
    @State private var imageUrl: URL? = Bundle.main.url(forResource: "brown_idle_8fps", withExtension: "gif")
    private let HorizontalStepSize: CGFloat = 7 // 每次移动的步长
    private let VerticalStepSize: CGFloat = 7 // 每次移动的步长
    
    // 定义传入的参数
    
    var body: some View {
        WebImage(url: imageUrl)
        .resizable()
        .scaledToFit()
        .frame(width: 40, height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: 2) // 设置边框颜色和宽度
        )
        .scaleEffect(x: isMovingRight ? 1 : -1, y: 1) // 水平翻转
        .offset(x: offsetX, y: offsetY)
        .onChange(of: status) { newValue in
            imageUrl = getImageUrl() // 当 isStop 变化时更新图片 URL
        }
    }
    
    // 动态选择图片 URL
    func getImageUrl() -> URL? {
        if status == .standing {
            return Bundle.main.url(forResource: "brown_idle_8fps", withExtension: "gif")
        } else {
            return Bundle.main.url(forResource: "brown_walk_fast_8fps", withExtension: "gif")
        }
    }
}
