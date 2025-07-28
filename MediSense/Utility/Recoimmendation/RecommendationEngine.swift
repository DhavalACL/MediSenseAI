//
//  RecommendationEngine.swift
//  MediSense
//
//  Created by Dhaval Upendrakumar Trivedi on 27/07/25.
//

import Foundation
// MARK: - Engine

public final class RecommendationEngine {

    public static let shared = RecommendationEngine()

    private let rulesFileName = "Recommendation"
    private var rulesBundle: RecommendationRules?

    private init() {
        rulesBundle = Self.loadRules(from: rulesFileName)
    }

    /// Main entry point.
    public func recommend(for profile: PatientProfile) -> RecommendationResult {
        guard let bundle = rulesBundle else {
            // Fallback hard defaults
            return RecommendationResult(
                treatment: ["Consult your physician for a personalized plan"],
                lifestyle: ["Maintain a balanced diet and regular activity"],
                therapy: [],
                priority: 0,
                matchedRule: nil,
                usedDefault: true
            )
        }

        // Filter rules based on disease key (if provided), otherwise consider all
        let candidateRules = bundle.rules.filter { rule in
            if let key = profile.diseaseKey {
                return rule.diseaseKey == key
            } else {
                // No disease key => accept rules that don't have it
                return rule.diseaseKey == nil
            }
        }

        // Evaluate each candidate
        let matched = candidateRules
            .filter { rule in
                Self.rule(rule, matches: profile)
            }
            .sorted { ($0.priority ?? bundle.defaults.priority) > ($1.priority ?? bundle.defaults.priority) }
            .first

        // If nothing matched, fall back to defaults
        guard let rule = matched else {
            return RecommendationResult(
                treatment: bundle.defaults.treatment,
                lifestyle: bundle.defaults.lifestyle,
                therapy: bundle.defaults.therapy,
                priority: bundle.defaults.priority,
                matchedRule: nil,
                usedDefault: true
            )
        }

        // Return matched rule (priority fallback to defaults if nil)
        return RecommendationResult(
            treatment: rule.treatment,
            lifestyle: rule.lifestyle,
            therapy: rule.therapy.isEmpty ? bundle.defaults.therapy : rule.therapy,
            priority: rule.priority ?? bundle.defaults.priority,
            matchedRule: rule,
            usedDefault: false
        )
    }
}
