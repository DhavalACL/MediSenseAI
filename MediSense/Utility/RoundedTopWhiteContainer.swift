//
//  RoundedTopWhiteContainer.swift
//  MediSense
//
//  Created by Dhaval.Trivedi on 22/07/25.
//

import SwiftUI

struct RoundedTopWhiteContainer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 40))
        path.addQuadCurve(to: CGPoint(x: rect.width, y: 40),
                          control: CGPoint(x: rect.width / 2, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}
