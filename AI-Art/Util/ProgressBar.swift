//
//  ProgressBar.swift
//  AI-Art
//
//  Created by Phyo on 24/5/24.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Double
    var color: Color
    var height: CGFloat

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: height) // Use dynamic width
                        .opacity(0.1)
                        .foregroundColor(color)

                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [color.opacity(0.5), color.opacity(0.8)]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: CGFloat(progress) * geometry.size.width, height: height) // Dynamic progress width
                        .animation(.linear, value: progress)
                }
            }
        }
    }
}
