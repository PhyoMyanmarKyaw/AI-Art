//
//  PromptSettings.swift
//  AI-Art
//
//  Created by Phyo on 24/5/24.
//

import Foundation

struct PromptSettings {
    var positivePrompt: String = ""
    var negativePrompt: String = ""
    var cfgScale: Double = 5.0
    var steps: Double = 15
}
