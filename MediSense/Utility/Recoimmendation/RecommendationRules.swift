//
//  RecommendationRules.swift
//  MediSense
//
//  Created by Dhaval Upendrakumar Trivedi on 27/07/25.
//

import Foundation


// MARK: - JSON Models

public struct RecommendationRules: Codable {
    public let rules: [Rule]
    public let defaults: DefaultRecommendation
}

public struct Rule: Codable {
    public let diseaseKey: String?
    public let conditions: Conditions?
    public let priority: Int?
    public let treatment: [String]
    public let lifestyle: [String]
    public let therapy: [String]
}

public struct Conditions: Codable {
    public let ageMin: Int?
    public let ageMax: Int?
    public let bmiMin: Double?
    public let bmiMax: Double?
    public let bp: BloodPressureCondition?
    public let smoking: Bool?
}

public struct BloodPressureCondition: Codable {
    public let systolicMin: Int?
    public let systolicMax: Int?
    public let diastolicMin: Int?
    public let diastolicMax: Int?
}

public struct DefaultRecommendation: Codable {
    public let priority: Int
    public let treatment: [String]
    public let lifestyle: [String]
    public let therapy: [String]
}

// MARK: - Loader

extension RecommendationEngine {
    static func loadRules(from resource: String) -> RecommendationRules? {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("❌ Could not find or read \(resource).json in bundle")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let resultData = try decoder.decode(RecommendationRules.self, from: data)
            return resultData
        } catch {
            print("❌ Failed to decode \(resource).json: \(error)")
            return nil
        }
    }
}


/// What you get back.
public struct RecommendationResult {
    public let treatment: [String]
    public let lifestyle: [String]
    public let therapy: [String]
    public let priority: Int
    public let matchedRule: Rule?   // nil if defaults used
    public let usedDefault: Bool
}
