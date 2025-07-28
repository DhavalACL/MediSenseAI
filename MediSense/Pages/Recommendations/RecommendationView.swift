//
//  PatientInputView.swift
//  MediSense
//
//  Created by Dhaval Upendrakumar Trivedi on 26/07/25.
//

import SwiftUI
import Photos

struct RecommendationView: View {
    @Environment(\.dismiss) private var dismiss
    let profile: PatientProfile

    private var recommendation: RecommendationResult {
        RecommendationEngine.shared.recommend(for: profile)
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Header
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your Health Plan")
                                .font(.largeTitle)
                                .bold()
                            Text("Personalized recommendations based on your health profile")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Text(priorityLabel)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(priorityColor.opacity(0.1))
                            .foregroundColor(priorityColor)
                            .cornerRadius(12)
                            .font(.subheadline.weight(.semibold))
                    }

                    // Snapshot section
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            snapshotRow(title: "Age", value: "\(profile.age ?? 0)")
                            snapshotRow(title: "BMI", value: String(format: "%.1f", profile.bmi ?? 0))
                            snapshotRow(title: "Blood Pressure", value: "\(profile.systolicBP ?? 0)/\(profile.diastolicBP ?? 0)")
                            snapshotRow(title: "Smoking", value: (profile.smokes ?? false) ? "Yes" : "No")
                            snapshotRow(title: "Activity", value: profile.activity?.rawValue ?? "-")
                        }
                        .padding(6)
                    } label: {
                        Label("Snapshot", systemImage: "person.text.rectangle")
                            .font(.headline)
                    }

                    // Recommendations sections
                    section(title: "💊 Treatment Suggestions", bullets: recommendation.treatment)
                    section(title: "🏃 Lifestyle Recommendations", bullets: recommendation.lifestyle)
                    section(title: "🧘 Therapy Options", bullets: recommendation.therapy)
                }
                .padding()
            }

            Button("Export Summary") {
                exportSnapshot()
            }
            .font(.title3.bold())
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .navigationTitle("Recommendations")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
            }
        }
    }

    private var priorityLabel: String {
        switch recommendation.priority {
        case 5: return "🔥 High Priority"
        case 4: return "⚠️ Moderate Priority"
        default: return "🟢 Low Priority"
        }
    }

    private var priorityColor: Color {
        switch recommendation.priority {
        case 5: return .red
        case 4: return .orange
        default: return .green
        }
    }

    private func snapshotRow(title: String, value: String) -> some View {
        HStack {
            Text("\(title):")
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
    }

    private func section(title: String, bullets: [String]) -> some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 10) {
                if bullets.isEmpty {
                    Text("No suggestions available.")
                        .italic()
                        .foregroundColor(.gray)
                } else {
                    ForEach(bullets, id: \.self) { line in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                            Text(line)
                        }
                    }
                }
            }
            .padding(.vertical, 6)
        } label: {
            Text(title)
                .font(.headline)
        }
    }
    
    private func exportSnapshot() {
        let exportSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 800) // Adjust height as needed

        let cardView = VStack(alignment: .leading, spacing: 16) {
            Text("Your Health Plan").font(.title).bold()
            GroupBox("Snapshot") {
                VStack(alignment: .leading, spacing: 8) {
                    snapshotRow(title: "Age", value: "\(profile.age ?? 0)")
                    snapshotRow(title: "BMI", value: String(format: "%.1f", profile.bmi ?? 0))
                    snapshotRow(title: "BP", value: "\(profile.systolicBP ?? 0)/\(profile.diastolicBP ?? 0)")
                    snapshotRow(title: "Smokes", value: (profile.smokes ?? false) ? "Yes" : "No")
                    snapshotRow(title: "Activity", value: profile.activity?.rawValue ?? "-")
                }
            }

            section(title: "💊 Treatment Suggestions", bullets: recommendation.treatment)
            section(title: "🏃 Lifestyle Recommendations", bullets: recommendation.lifestyle)
            section(title: "🧘 Therapy Options", bullets: recommendation.therapy)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)

        SnapshotViewRenderer.render(cardView, size: exportSize) { image in
            guard let image = image else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
