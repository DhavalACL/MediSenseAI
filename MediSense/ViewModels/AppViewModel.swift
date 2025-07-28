import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var postop: CGFloat = 0.0
    
    @Published var image: UIImage? = nil
    
    @Published var isLoading = false
    @Published var selectedImage: UIImage? = nil
    @Published var resultLabel: String? = nil
    @Published var currentDiseaseKey: String? = nil
    @Published var showFinalResult = false
        
    let predictionsToShow = 1
    
    func topup(_ direction: String) {
        if direction == "up" {
            postop = 0.5 // 50% of screen height
        } else {
            postop = 0.75
        }
    }
    
    func clearImage() {
        image = nil
    }
    
    func classifyWith(image: UIImage, modelKind: ClinicalModel, completion: @escaping ([ImagePredictor.Prediction]?) -> Void) {
        do {
            let imagePredictor = ImagePredictor(modelKind: modelKind)
            try imagePredictor.makePredictions(for: image,
                                                    completionHandler: completion)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }
    
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        guard let predictions = predictions else {
            print("No predictions. (Check console log.)")
            return
        }

        let formattedPredictions = formatPredictions(predictions)

        let predictionString = formattedPredictions.joined(separator: "\n")
    }
    
    func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification

            // For classifications with more than one name, keep the one before the first comma.
            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }

            return "\(name) - \(prediction.confidencePercentage)%"
        }

        return topPredictions
    }
}
