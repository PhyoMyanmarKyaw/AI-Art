//
//  ContentView.swift
//  AI-Art
//
//  Created by Phyo on 24/5/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: ImageGenerationViewModel
    @State private var showingAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                if let image = viewModel.generatedImage {
                    Text("")
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 400)
                    
                    if !viewModel.hasSavedImage {
                        Button("Save to Gallery") {
                            viewModel.saveImageToGallery()
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .transition(.opacity)
                        .animation(.easeInOut, value: viewModel.hasSavedImage)
                    }
                    
                } else {
                    if viewModel.isLoading {
                        ShimmerView()
                            .overlay(
                                VStack(spacing: 4) {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text(viewModel.statusMessage)
                                            .foregroundStyle(.mainText)
                                            .font(.footnote)
                                            .padding(.trailing, 10)
                                            .padding(.bottom, 6)
                                    }
                                    ProgressBar(progress: viewModel.progress, color: .purpleLight, height: 35)
                                        .frame(height: 35)
                                }
                            )
                        
                    } else {
                        LinearGradient(gradient: Gradient(colors: [ Color.purpleLight.opacity(0.1), .black.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                            .frame(height: 300)
                    }
                }
                
                TextField("Enter positive prompt", text: $viewModel.promptSettings.positivePrompt, axis: .vertical)
                    .textFieldStyle(CustomTextFieldStyle())
                    .lineLimit(3...6)
                
                
                TextField("Enter negative prompt", text: $viewModel.promptSettings.negativePrompt, axis: .vertical)
                    .lineLimit(2...5)
                    .textFieldStyle(CustomTextFieldStyle())
                
                HStack(alignment:.top, spacing: 26) {
                    Text("STEPS :")
                    CustomSliderView(value: $viewModel.promptSettings.steps, range:  1...50)
                        .frame(height: 30)
                    Text("\(Int(viewModel.promptSettings.steps))")
                }
                .foregroundStyle(.mainText)
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                
                HStack(alignment:.top, spacing: 26) {
                    Text("SCALE :")
                        .foregroundStyle(.mainText)
                    CustomSliderView(value: $viewModel.promptSettings.cfgScale, range:  0.1...20.0)
                        .frame(height: 30)
                    Text("\(viewModel.promptSettings.cfgScale, specifier: "%.1f")")
                        .foregroundStyle(.mainText)
                }
                .padding(.horizontal, 20)
                
                
                Button(action: {
                    if viewModel.isLoading {
                        viewModel.cancelImageGeneration()
                    } else {
                        viewModel.generateImage()
                    }
                }) {
                    HStack {
                        Image(systemName: viewModel.isLoading ? "wrongwaysign" : "photo.circle.fill")
                            .foregroundColor(.black)
                        Text(viewModel.isLoading ? "Cancel" : "Generate Image")
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isLoading ? Color.red : .white)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.top,10)
                
                Spacer()
            }
            .gesture(
                TapGesture()
                    .onEnded {
                        UIApplication.shared.endEditing()
                    }
            )
        }
        .alert(isPresented: $viewModel.showingImageSavedAlert) {
            Alert(title: Text("Save Image"), message: Text(viewModel.alertMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
        .onChange(of: viewModel.alertMessage) {
            showingAlert = true
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            BackgroundGradientView()
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let mockService = MockImageGenerationService()
        ContentView(viewModel: ImageGenerationViewModel(imageGenerationService: mockService))
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
