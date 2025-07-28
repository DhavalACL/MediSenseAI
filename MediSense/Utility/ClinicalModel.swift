//
//  DiseaseType.swift
//  MediSense
//
//  Created by Dhaval Upendrakumar Trivedi on 26/07/25.
//

import Foundation
import CoreML
import Vision

enum ClinicalModel: String {
    case brainTumour
    case pneumonia
    case heartDisease

    func makeVNModel(configuration: MLModelConfiguration = .init()) throws -> VNCoreMLModel {
        switch self {
        case .brainTumour:
            return try VNCoreMLModel(for: BrainTumourClassifier(configuration: configuration).model)
        case .pneumonia:
            return try VNCoreMLModel(for: PneumoniaClassifier(configuration: configuration).model)
        case .heartDisease:
            return try VNCoreMLModel(for: PneumoniaClassifier(configuration: configuration).model)
        }
    }
}
