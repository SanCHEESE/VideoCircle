//
//  SKShapeNode+Circle.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 16.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import SpriteKit

/// Utility extension
extension SKShapeNode {

    /// Set radius manually after node initialization
    var radius: CGFloat {
        set {
            let path: CGMutablePath = CGMutablePath()
            path.addEllipse(in: CGRect(x: 0, y: 0, width: newValue * 2, height: newValue * 2))
            self.path = path
        }

        get { return self.path!.boundingBox.size.width/2 }
    }

    func addDefaultPhysicsBehaviour() {
        let physicsBody = SKPhysicsBody(circleOfRadius: self.radius)
        physicsBody.collisionBitMask = App.bodyCollisionBitMask
        physicsBody.categoryBitMask = App.bodyCollisionBitMask
        physicsBody.contactTestBitMask = App.bodyCollisionBitMask
        physicsBody.allowsRotation = false
        self.physicsBody = physicsBody
    }
}
