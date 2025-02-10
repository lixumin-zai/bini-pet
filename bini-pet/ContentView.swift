//
//  ContentView.swift
//  bini-pet
//
//  Created by lixumin on 2025/1/21.
//

import SwiftUI
import SDWebImageSwiftUI

// BlurView remains the same
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}


struct FrostedGlassCard: View {
    @State private var inputText: String = "" // 用于绑定输入框的文本
    
    var body: some View {
        Sence()
            .frame(width: 300, height: 300)
    }
}

struct ContentView: View {
    var body: some View {
        FrostedGlassCard()
        .padding(20)
    }
}


//#Preview {
//    ContentView()
//}
