//
//  Pipeline.swift
//  AI-Art
//
//  Created by Phyo on 24/5/24.
//

import CoreML
import UIKit
import StableDiffusion

class Pipeline {
    private var pipeline: StableDiffusionPipeline?
    private var cancellationFlag = false
    
    init() {
        loadPipeline()
    }
    
    func cancelGeneration() {
        cancellationFlag =  true
    }
    
    private func loadPipeline() {
        guard let resourceURL = Bundle.main.resourceURL else {
            print("Resource URL not found")
            return
        }
        let config = MLModelConfiguration()
        config.computeUnits = .cpuAndGPU
        
        do {
            pipeline = try StableDiffusionPipeline(resourcesAt: resourceURL,
                                                   controlNet: [],
                                                   configuration: config,
                                                   disableSafety: false,
                                                   reduceMemory: true)
        } catch {
            print("Failed to initialize Stable Diffusion Pipeline: \(error)")
        }
    }
    
    func generateImages(configuration: StableDiffusionPipeline.Configuration, progressHandler: @escaping (StableDiffusionPipeline.Progress) -> Bool) throws -> [CGImage?] {
        guard let pipeline = pipeline else {
            throw NSError(domain: "PipelineError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Pipeline not initialized"])
        }
        // Reset the flag at the start of each generation
        cancellationFlag = false
        //return try pipeline.generateImages(configuration: configuration, progressHandler: progressHandler)
        return try pipeline.generateImages(configuration: configuration) { progress in
            DispatchQueue.main.async {
                progressHandler(progress)
            }
            return !self.cancellationFlag  // Continue only if not cancelled
        }
    }
    
    func reset() {
        pipeline = nil
        loadPipeline()
    }
}
