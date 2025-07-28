//
//  PneumoniaClassifyView.swift
//  MediSense
//
//  Created by Dhaval Upendrakumar Trivedi on 26/07/25.
//

import SwiftUI

struct PneumoniaClassifyView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var showAlert = false
    @State private var classificationLabel = ""
    
    @State private var showActionSheet = false
    @State private var showImagePicker = false
    @State private var selectedSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    var lottieAnimationName: String
    var imageMean: Double
    var imageStd: Double
    var numResults: Int
    var threshold: Double

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                ScrollView {
                    if (selectedImage == nil) {
                        VStack(spacing: 20) {
                            LottieView(name: lottieAnimationName)
                                .frame(height: 300)
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("Detect Pneumonia")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.clearImage()
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                Spacer()  // Push content to center vertically
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(12)
                        .onAppear {
                            viewModel.classifyWith(image: image, modelKind: .pneumonia) { result in
                                print(result ?? "")
                                guard let result = result else {
                                    return
                                }
                                let formattedPredictions = viewModel.formatPredictions(result)
                                let predictionString = formattedPredictions.joined(separator: "\n")
                                if predictionString.count >= 2 {
                                    let idx = predictionString.index(predictionString.endIndex, offsetBy: -2)
                                    if predictionString[idx] == "%" {
                                        let resultLabel = String(predictionString.dropLast())
                                        let diseaseKey = resultLabel.components(separatedBy: "-").first?.trimmingCharacters(in: .whitespaces)
                                        viewModel.currentDiseaseKey = "pneumonia-" + (diseaseKey ?? "")
                                        viewModel.resultLabel = resultLabel
                                    }
                                } else {
                                    let resultLabel = String(predictionString.dropLast())
                                    let diseaseKey = resultLabel.components(separatedBy: "-").first?.trimmingCharacters(in: .whitespaces)
                                    viewModel.currentDiseaseKey = "pneumonia-" + (diseaseKey ?? "")
                                    viewModel.resultLabel = resultLabel
                                }
                            }
                        }
                } else {
                    Text("No Image Selected")
                        .foregroundColor(.gray)
                }
                
                Spacer()  // Push content to center vertically

                if let resultString = viewModel.resultLabel {
                    
                    VStack(alignment: .leading) {
                        Text("Result: ")
                            .font(.title3)
                            .foregroundColor(.black)
                        
                        Text(resultString)
                            .foregroundColor(.gray)
                    }
                    
                    NavigationLink(destination: PatientInputView(diseaseKey: "pneumonia-bacterial").navigationBarBackButtonHidden(true)) {
                        Text("Next")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .padding(.horizontal, 20)
                    }
                }
                
                Button("Choose Image") {
                    showActionSheet = true
                }
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.horizontal, 20)
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text("Select Image"), buttons: [
                        .default(Text("Camera")) {
                            selectedSource = .camera
                            showImagePicker = true
                        },
                        .default(Text("Photo Library")) {
                            selectedSource = .photoLibrary
                            showImagePicker = true
                        },
                        .cancel()
                    ])
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(sourceType: selectedSource, selectedImage: $selectedImage)
                }
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(classificationLabel),
                message: Text("Warning: this result may not be accurate. Consult a doctor as soon as possible.\n(The accuracy of the results is 91%)"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
