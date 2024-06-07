//
//  ImageGenerationService.swift
//  AI-Art
//
//  Created by Phyo on 24/5/24.
//

import Combine
import UIKit
import StableDiffusion

protocol ImageGenerationServiceProtocol {
    var statePublisher: PassthroughSubject<ModelState, Never> { get }
    func generateImage(with settings: PromptSettings)
    func cancelImageGeneration()
    func cleanupPipeline()
}

enum ModelState {
    case initializing(status: String)
    case processing(progress: Double, status: String)
    case complete(image: CGImage?)
    case canceled
    case error(String)
}

class ImageGenerationService: ImageGenerationServiceProtocol {
    private let pipeline: Pipeline
    let statePublisher = PassthroughSubject<ModelState, Never>()
    
    init(pipeline: Pipeline) {
        self.pipeline = pipeline
        self.statePublisher.send(.initializing(status: "loading..."))
    }
    
    func cancelImageGeneration() {
        pipeline.cancelGeneration()
        statePublisher.send(.canceled)
    }
    
    func cleanupPipeline() {
        pipeline.reset()  // Reset the pipeline after generation
    }
    
    func generateImage(with settings: PromptSettings) {
        self.statePublisher.send(.processing(progress: 0.0, status: "preparing..."))
        
        DispatchQueue.global().async {
            
            var pipelineConfig = StableDiffusionPipeline.Configuration(prompt: settings.positivePrompt)
            pipelineConfig.schedulerType = .dpmSolverMultistepScheduler
            pipelineConfig.stepCount = Int(settings.steps)
            pipelineConfig.negativePrompt = settings.negativePrompt
            pipelineConfig.guidanceScale = Float(settings.cfgScale)
            pipelineConfig.seed = UInt32.random(in: 0...UInt32.max)
            pipelineConfig.imageCount = 1
            print("Pipeline config: ", pipelineConfig)
            
            do {
                let images = try self.pipeline.generateImages(configuration: pipelineConfig) { progress in
                    DispatchQueue.main.async {
                        self.statePublisher.send(.processing(progress: Double(progress.step) / Double(progress.stepCount),
                                                             status: "running step ... \(progress.step.description)"))
                    }
                    return true
                }
                DispatchQueue.main.async {
                    if let cgImage = images.first ?? nil {
                        self.statePublisher.send(.complete(image: cgImage))
                    } else {
                        self.statePublisher.send(.error("No images generated."))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.statePublisher.send(.error("Failed to generate images: \(error.localizedDescription)"))
                }
            }
        }
    }
}

class MockImageGenerationService: ImageGenerationServiceProtocol {
    let statePublisher = PassthroughSubject<ModelState, Never>()
    private var isCancelled = false

    func cleanupPipeline() {
        // Clean up resources if needed
    }

    func cancelImageGeneration() {
        print("cancel")
        isCancelled = true
    }

    func generateImage(with settings: PromptSettings) {
        isCancelled = false
        // Simulate initial loading
        statePublisher.send(.initializing(status: "preparing..."))

        let totalSteps = 12
        for step in 1...totalSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(step)) { [weak self] in
                guard let self = self, !self.isCancelled else { return }

                if step < totalSteps {
                    // Simulate processing
                    let progress = Double(step) / Double(totalSteps)
                    self.statePublisher.send(.processing(progress: progress, status: "running step..\(step)"))
                } else {
                    // Simulate completion
                    if let cgImage = UIImage(systemName: "photo")?.cgImage {
                        self.statePublisher.send(.complete(image: cgImage))
                    } else {
                        self.statePublisher.send(.error("Mock: Failed to generate image."))
                    }
                }
            }
        }
    }
}
