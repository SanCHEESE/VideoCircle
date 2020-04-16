//
//  VideoCircleNode.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 15.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import Foundation
import SpriteKit

/// Circle with video stream
final class VideoCircleNode: SKShapeNode {

    static let name = "VideoCircle"

    var frameProvider: FrameProvider

    init(radius: CGFloat, frameProvider: FrameProvider) {

        self.frameProvider = frameProvider

        super.init()

        self.frameProvider.delegate = self
        self.radius = radius
        
        name = Self.name

        setupAppearance()
        setupPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private -

    private func setupAppearance() {
        strokeColor = .black
        lineWidth = 1
        fillColor = .white
    }

    private func setupPhysics() {
        addDefaultPhysicsBehaviour()

        guard let body = physicsBody else { return }
        body.restitution = 0
        body.mass = 1
        body.friction = 0.5
        body.linearDamping = 0
    }
}

extension VideoCircleNode: FrameProviderDelegate {
    func captured(image: UIImage) {
        DispatchQueue.main.async {
            self.fillTexture = SKTexture(image: image)
        }
    }
}
