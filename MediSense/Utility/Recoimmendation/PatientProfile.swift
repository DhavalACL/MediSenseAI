//
//  PatientProfile.swift
//  MediSense
//
//  Created by Dhaval Upendrakumar Trivedi on 27/07/25.
//

import Foundation

public struct PatientProfile {
    public var age: Int?
    public var gender: Gender?          // NEW
    public var heightCm: Double?        // NEW
    public var weightKg: Double?        // NEW
    public var bmi: Double?
    public var systolicBP: Int?
    public var diastolicBP: Int?
    public var activity: ActivityLevel? // NEW
    public var smokes: Bool?
    /// Optional – set if a classifier picked something; nil if user skipped detection.
    public var diseaseKey: String?

    public init(age: Int? = nil,
                gender: Gender? = nil,
                heightCm: Double? = nil,
                weightKg: Double? = nil,
                bmi: Double? = nil,
                systolicBP: Int? = nil,
                diastolicBP: Int? = nil,
                activity: ActivityLevel? = nil,
                smokes: Bool? = nil,
                diseaseKey: String? = nil) {
        self.age = age
        self.gender = gender
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.bmi = bmi
        self.systolicBP = systolicBP
        self.diastolicBP = diastolicBP
        self.activity = activity
        self.smokes = smokes
        self.diseaseKey = diseaseKey
    }
}

public enum Gender: String, CaseIterable, Identifiable, Codable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
    public var id: String { rawValue }
}

public enum ActivityLevel: String, CaseIterable, Identifiable, Codable {
    case sedentary = "Sedentary"
    case light = "Light"
    case moderate = "Moderate"
    case vigorous = "Vigorous"
    public var id: String { rawValue }
}
