//
//  CustomSlider.swift
//  AI-Art
//
//  Created by Phyo on 24/5/24.
//

import SwiftUI

struct CustomSliderView: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 5)
                
                Rectangle()
                    .fill(Color.orange.opacity(0.5))
                    .frame(width: geometry.size.width * CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)), height: 5)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 28, height: 28)
                    .offset(x: geometry.size.width * CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) - 10)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let sliderPosition = gesture.location.x / geometry.size.width
                                let sliderValue = Double(sliderPosition) * (range.upperBound - range.lowerBound) + range.lowerBound
                                self.value = min(max(sliderValue, range.lowerBound), range.upperBound)
                            }
                    )
            }
        }
    }
}

