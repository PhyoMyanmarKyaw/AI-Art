//
//  AI_ArtApp.swift
//  AI-Art
//
//  Created by Phyo on 24/5/24.
//

import SwiftUI

@main
struct AI_ArtApp: App {
    var body: some Scene {
        WindowGroup {
            let service = ImageGenerationService(pipeline: Pipeline())
            let viewModel = ImageGenerationViewModel(imageGenerationService: service)
            ContentView(viewModel: viewModel)
        }
    }
}
