//
//  MainViewModel.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 16.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import Foundation
import SpriteKit

final class MainViewModel: ViewModel {
    let coordinator: Coordinator

    /// Nodes for displaying
    var nodes: [SKShapeNode] = []
    private var videoCircle: VideoCircleNode? { nodes.filter({ $0 is VideoCircleNode }).first as? VideoCircleNode }
    private var coloredCircle: ColoredCircleNode? { nodes.filter({ $0 is ColoredCircleNode }).first as? ColoredCircleNode }

    init(coordinator: Coordinator) {
        self.coordinator = coordinator

        createCircles()
    }

    // reset position of nodes
    func resetPositions() {
        if let videoCircle = self.videoCircle {
            videoCircle.position = CGPoint(x: 50, y: 50) // left bottom corner
            videoCircle.physicsBody?.affectedByGravity = false
        }

        if let coloredCircle = self.coloredCircle {
            coloredCircle.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2) // center
            coloredCircle.gravityEnabled = false
        }
    }

    func animate() {
        guard let coloredCircle = self.coloredCircle else { return }
        coloredCircle.gravityEnabled = true
    }

    // MARK: - Private -

    private func createCircles() {
        let cameraFrameProvider = CameraFrameProvider()
        cameraFrameProvider.imageCropper = SquareImageCropper(cropSize: CGSize(width: App.defaultCircleRadius, height: App.defaultCircleRadius))
        let videoCircle: VideoCircleNode = VideoCircleNode(radius: App.defaultCircleRadius, frameProvider: cameraFrameProvider)
        nodes.append(videoCircle)

        let coloredCircle: ColoredCircleNode = ColoredCircleNode(radius: App.defaultCircleRadius)
        coloredCircle.gravityEnabled = false
        nodes.append(coloredCircle)

        resetPositions()
    }
}
