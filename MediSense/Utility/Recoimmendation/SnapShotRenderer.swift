//
//  SnapShotRenderer.swift
//  MediSense
//
//  Created by Dhaval Upendrakumar Trivedi on 28/07/25.
//

import SwiftUI

struct SnapshotViewRenderer {
    static func render<V: View>(_ view: V, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let controller = UIHostingController(rootView: view)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: size)
        DispatchQueue.main.async {
            let image = renderer.image { _ in
                controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
            completion(image)
        }
    }
}
