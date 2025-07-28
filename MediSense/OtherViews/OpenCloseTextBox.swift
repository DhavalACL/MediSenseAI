//
//  OpenCloseTextBox.swift
//  MediSense
//
//  Created by Dhaval Upendrakumar Trivedi on 26/07/25.
//

import SwiftUI

struct OpenCloseTextBox: View {
    var title: String
    var text: String
    var backgroundColor: Color = .blue
    var textColor: Color = .white

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(textColor)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(textColor)
                }
                .padding()
                .background(backgroundColor)
                .cornerRadius(8)
            }

            if isExpanded {
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .transition(.opacity)
            }
        }
    }
}
