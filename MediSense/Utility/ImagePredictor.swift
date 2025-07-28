//
//  ImagePredictor.swift
//  MediSense
//
//  Created by Dhaval.Trivedi on 22/07/25.
//

import Vision
import UIKit

class ImagePredictor {
    /// The VNCoreMLModel used for prediction.
    private let imageClassifier: VNCoreMLModel

    /// Inject the model type (BrainTumour, Pneumonia, etc.)
    init(modelKind: ClinicalModel) {
        do {
            self.imageClassifier = try modelKind.makeVNModel()
            print("Selected model: ", modelKind)
        } catch {
            fatalError("Failed to create VNCoreMLModel for \(modelKind.rawValue): \(error)")
        }
    }

    /// Stores a classification name and confidence for an image classifier's prediction.
    struct Prediction {
        let classification: String
        let confidencePercentage: String
    }

    typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void

    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()

    /// Generates a new request instance that uses the selected model.
    private func createImageClassificationRequest() -> VNImageBasedRequest {
        let request = VNCoreMLRequest(model: self.imageClassifier,
                                      completionHandler: visionRequestHandler)
        request.imageCropAndScaleOption = .centerCrop
        return request
    }

    /// Runs predictions on a UIImage.
    func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) throws {
        let orientation = CGImagePropertyOrientation(photo.imageOrientation)

        guard let photoImage = photo.cgImage else {
            fatalError("Photo doesn't have underlying CGImage.")
        }

        let request = createImageClassificationRequest()
        predictionHandlers[request] = completionHandler

        let handler = VNImageRequestHandler(cgImage: photoImage, orientation: orientation)
        try handler.perform([request])
    }

    /// Handles Vision request results.
    private func visionRequestHandler(_ request: VNRequest, error: Error?) {
        guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
            fatalError("Every request must have a prediction handler.")
        }

        var predictions: [Prediction]? = nil
        defer { predictionHandler(predictions) }

        if let error = error {
            print("Vision error: \(error.localizedDescription)")
            return
        }

        guard let observations = request.results as? [VNClassificationObservation] else {
            print("Unexpected result type: \(String(describing: request.results))")
            return
        }

        predictions = observations.map {
            Prediction(classification: $0.identifier,
                       confidencePercentage: $0.confidencePercentageString)
        }
    }
}
