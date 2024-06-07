//
//  CustomTextFieldStyle.swift
//  AI-Art
//
//  Created by Phyo on 24/5/24.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(.bgLight)
            .foregroundStyle(.mainText)
            .cornerRadius(10)
            .padding(.horizontal, 15)
    }
}
