//
//  ColoredCircleNode.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 16.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import Foundation
import SpriteKit

final class ColoredCircleNode: SKShapeNode {

    static let name = "ColoredCircle"

    init(radius: CGFloat) {
        super.init()

        self.radius = radius

        name = Self.name

        setupAppearance()
        setupPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var position: CGPoint {
        didSet {
            super.position = position
            guard let gravField = children.first else { return }
            gravField.position = self.position
        }
    }

    var gravityEnabled: Bool = false {
        didSet {
            guard let gravField = children.first as? SKFieldNode else { return }
            gravField.isEnabled = gravityEnabled
        }
    }

    // MARK: - Private -

    func setupAppearance() {
        fillColor = .red
        strokeColor = .black
        lineWidth = 1
    }

    func setupPhysics() {
        addDefaultPhysicsBehaviour()

        // add gravity
        let field = SKFieldNode.radialGravityField()
        field.strength = 10
        field.animationSpeed = 19
        addChild(field)

        guard let physicsBody = physicsBody else { return }
        physicsBody.pinned = true
        physicsBody.mass = 100
    }
}
