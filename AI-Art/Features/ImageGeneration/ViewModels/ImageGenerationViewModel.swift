//
//  ImageGenerationViewModel.swift
//  AI-Art
//
//  Created by Phyo on 24/5/24.
//

import Combine
import SwiftUI
import UIKit

class ImageGenerationViewModel: NSObject, ObservableObject {
    @Published var promptSettings = PromptSettings()
    @Published var generatedImage: UIImage?
    @Published var isLoading = false
    @Published var progress: Double = 0.0
    @Published var statusMessage = "Ready"
    @Published var alertMessage: String? = nil
    @Published var hasSavedImage = false
    @Published var showingImageSavedAlert = false
    
    private var cancellables = Set<AnyCancellable>()
    private let imageGenerationService: ImageGenerationServiceProtocol
    
    init(imageGenerationService: ImageGenerationServiceProtocol) {
        self.imageGenerationService = imageGenerationService
        super.init()
        observeImageGeneration()
    }
    
    private func observeImageGeneration() {
        imageGenerationService.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .initializing(let status):
                    self?.isLoading = true
                    self?.statusMessage = status
                case .processing(let progress, let status):
                    self?.isLoading = true
                    self?.progress = progress
                    self?.statusMessage = status
                case .complete(let cgImage):
                    self?.isLoading = false
                    if let cgImage = cgImage {
                        self?.generatedImage = UIImage(cgImage: cgImage)
                    }
                    self?.statusMessage = "Generation Complete"
                    self?.hasSavedImage = false
                case .canceled:
                    self?.isLoading = false
                    self?.statusMessage = "Generation Canceled"
                case .error(let error):
                    self?.isLoading = false
                    self?.statusMessage = error
                    self?.alertMessage = error
                }
            }
            .store(in: &cancellables)
    }
    
    func generateImage() {
        reset()
        imageGenerationService.generateImage(with: promptSettings)
    }
    
    func reset() {
        generatedImage = nil
        isLoading = false
        progress = 0.0
        statusMessage = "Initializing..."
        hasSavedImage = false
        showingImageSavedAlert = false
    }
    
    func cancelImageGeneration() {
        imageGenerationService.cancelImageGeneration()
        reset()
    }
    
    func resetPipeline() {
        imageGenerationService.cleanupPipeline()  // Clean up and reset pipeline
        reset()
    }
    
    func saveImageToGallery() {
        guard let image = generatedImage, !hasSavedImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            if let error = error {
                self.alertMessage = "Error saving image: \(error.localizedDescription)"
            } else {
                self.alertMessage = "Image successfully saved to your Photos."
                self.hasSavedImage = true
            }
            self.showingImageSavedAlert = true
        }
    }
}
