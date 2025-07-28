//
//  PatientInputView.swift
//  MediSense
//
//  Created by Dhaval Upendrakumar Trivedi on 26/07/25.
//

import SwiftUI

struct PatientInputView: View {
    // Inputs
    @State private var age: String = ""
    @State private var gender: Gender = .male
    @State private var height: String = ""      // in cm
    @State private var weight: String = ""      // in kg
    @State private var systolic: String = ""
    @State private var diastolic: String = ""
    @State private var activity: ActivityLevel = .sedentary
    @State private var smokes: Bool = false
    
    // Navigation
    @State private var goNext = false
    @State private var builtProfile: PatientProfile?
    
    // Validation
    @State private var showValidation = false
    @State private var validationMessage = ""
    @Environment(\.dismiss) private var dismiss
    
    var diseaseKey: String? = nil

    var bmi: Double {
        guard
            let h = Double(height), h > 0,
            let w = Double(weight), w > 0
        else { return 0 }
        let hMeters = h / 100.0
        return w / (hMeters * hMeters)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic")) {
                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                
                Picker("Gender", selection: $gender) {
                    ForEach(Gender.allCases) { g in
                        Text(g.rawValue).tag(g)
                    }
                }.pickerStyle(.segmented)
            }
            
            Section(header: Text("Body Metrics")) {
                TextField("Height (cm)", text: $height)
                    .keyboardType(.decimalPad)
                TextField("Weight (kg)", text: $weight)
                    .keyboardType(.decimalPad)
                
                HStack {
                    Text("BMI")
                    Spacer()
                    Text(bmi == 0 ? "-" : String(format: "%.1f", bmi))
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Blood Pressure")) {
                TextField("Systolic (e.g. 120)", text: $systolic)
                    .keyboardType(.numberPad)
                TextField("Diastolic (e.g. 80)", text: $diastolic)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Lifestyle")) {
                Picker("Activity", selection: $activity) {
                    ForEach(ActivityLevel.allCases) { lvl in
                        Text(lvl.rawValue).tag(lvl)
                    }
                }
                Toggle("Smokes", isOn: $smokes)
            }
            
            Button("Next") {
                if let profile = buildProfile() {
                    builtProfile = profile
                    goNext = true
                } else {
                    showValidation = true
                }
            }
            .font(.title2)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .navigationTitle("Patient Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                }
            }
        }
        .alert("Invalid input", isPresented: $showValidation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(validationMessage)
        }
        .navigationDestination(isPresented: $goNext) {
            if let profile = builtProfile {
                RecommendationView(profile: profile).navigationBarBackButtonHidden(true)
            }
        }
    }
    
    private func buildProfile() -> PatientProfile? {
        guard
            let ageVal = Int(age), ageVal > 0,
            let h = Double(height), h > 0,
            let w = Double(weight), w > 0,
            let sys = Int(systolic), sys > 0,
            let dia = Int(diastolic), dia > 0
        else {
            validationMessage = "Please fill all numeric fields correctly."
            return nil
        }

        let computedBMI = w / pow(h / 100.0, 2)

        return PatientProfile(
            age: ageVal,
            gender: gender,
            heightCm: h,
            weightKg: w,
            bmi: computedBMI,
            systolicBP: sys,
            diastolicBP: dia,
            activity: activity,
            smokes: smokes,
            diseaseKey: self.diseaseKey
        )
    }
}
