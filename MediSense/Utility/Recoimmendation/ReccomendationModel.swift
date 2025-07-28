//
//  ReccomendationModel.swift
//  MediSense
//
//  Created by Dhaval Upendrakumar Trivedi on 27/07/25.
//

import SwiftUI

// MARK: - Matching logic

extension RecommendationEngine {
    static func rule(_ rule: Rule, matches profile: PatientProfile) -> Bool {
        guard let cond = rule.conditions else { return true } // No conditions => always matches

        let toleranceAge = 5
        let toleranceBMI = 2.0
        let toleranceBP = 5
        
        // Example:
        if let min = cond.ageMin, let age = profile.age, age < min - toleranceAge { return false }
        if let max = cond.ageMax, let age = profile.age, age > max + toleranceAge { return false }
        if (cond.ageMin != nil || cond.ageMax != nil), profile.age == nil { return false }

        // BMI
        if let min = cond.bmiMin, let bmi = profile.bmi, bmi < min - toleranceBMI { return false }
        if let max = cond.bmiMax, let bmi = profile.bmi, bmi > max + toleranceBMI { return false }
        if (cond.bmiMin != nil || cond.bmiMax != nil), profile.bmi == nil { return false }

        // Smoking
        if let smokingRequired = cond.smoking,
           let userSmoking = profile.smokes {
            if smokingRequired != userSmoking { return false }
        } else if cond.smoking != nil, profile.smokes == nil {
            return false
        }

        // Blood pressure
        if let bpCond = cond.bp {
            // Systolic
            if let sMin = bpCond.systolicMin, let s = profile.systolicBP, s < sMin - toleranceBP { return false }
            if let sMax = bpCond.systolicMax, let s = profile.systolicBP, s > sMax + toleranceBP { return false }
            // Diastolic
            if let dMin = bpCond.diastolicMin, let d = profile.diastolicBP, d < dMin { return false }
            if let dMax = bpCond.diastolicMax, let d = profile.diastolicBP, d > dMax { return false }

            // If any BP bound exists but user provided nothing, non-match
            let needsSystolic = (bpCond.systolicMin != nil || bpCond.systolicMax != nil)
            let needsDiastolic = (bpCond.diastolicMin != nil || bpCond.diastolicMax != nil)
            if needsSystolic && profile.systolicBP == nil { return false }
            if needsDiastolic && profile.diastolicBP == nil { return false }
        }

        return true
    }
}
