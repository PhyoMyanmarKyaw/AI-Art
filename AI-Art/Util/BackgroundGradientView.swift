//
//  BackgroundGradientView.swift
//  QuickCount
//
//  Created by Phyo on 15/5/24.
//

import SwiftUI

struct BackgroundGradientView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [
            Color("BgTop"),
            Color("BgBottom")
        ]), startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    BackgroundGradientView()
}
