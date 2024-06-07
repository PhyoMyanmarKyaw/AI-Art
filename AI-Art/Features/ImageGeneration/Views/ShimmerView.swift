//
//  ShimmerView.swift
//  AI-Art
//
//  Created by Phyo on 24/5/24.
//

import Foundation
import SwiftUI

struct ShimmerView: View {
    @State private var isAnimating: Bool
    private let offset: CGFloat
    private let rotationAngle: Angle
    private let linearGradient: LinearGradient
    private let animation: Animation
    private let primaryColor: Color
    private let shimmerColor: Color
    private let size: CGSize
    private let shimmerSize: CGSize
    private let cornerRadius: CGFloat
    
    init(rotationAngle: Angle = Angle(degrees: 75),
         animationSpeed: CGFloat = 0.4,
         primaryColor: Color = .bgLight.opacity(0.1),
         shimmerColor: Color = .purpleLight.opacity(0.4),
         size: CGSize = CGSize(width: 350, height: 300),
         cornerRadius: CGFloat = 0) {
        self.offset = size.width * 1.5
        self.isAnimating = false
        self.rotationAngle = rotationAngle
        self.linearGradient = LinearGradient(colors: [shimmerColor.opacity(0.1),
                                                      shimmerColor,
                                                      shimmerColor.opacity(0.1)],
                                             startPoint: .top,
                                             endPoint: .bottom)
        self.animation = Animation.default.speed(animationSpeed).delay(0).repeatForever(autoreverses: false)
        self.primaryColor = primaryColor
        self.shimmerColor = shimmerColor
        self.size = size
        self.shimmerSize = CGSize(width: size.width * 1.5,
                                  height: size.width * 1.5)
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        primaryColor
            .frame(height: size.height)
            .overlay(shimmerLayer())
            .cornerRadius(cornerRadius)
            .onAppear {
                withAnimation(animation) {
                    isAnimating.toggle()
                }
            }
    }
    
    private func shimmerLayer() -> some View {
        return Rectangle()
            .fill(linearGradient)
            .frame(width: shimmerSize.width,
                   height: shimmerSize.height)
            .rotationEffect(rotationAngle)
            .offset(x: isAnimating ? offset : -offset)
    }
}

struct ShimmerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ShimmerView()
        }
        .previewLayout(.sizeThatFits)
    }
}
