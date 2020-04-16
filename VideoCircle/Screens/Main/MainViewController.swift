//
//  GameViewController.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 15.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import SpriteKit

// Main screen that display circles
final class MainViewController: UIViewController, View {
    typealias ViewModel = MainViewModel

    var viewModel: ViewModel? {
        didSet {
            reloadData()
        }
    }

    private lazy var scene: SKScene = {
        SKScene(size: UIScreen.main.bounds.size)
    }()

    // MARK: - UIViewController lifecycle -

    override func loadView() {
        view = SKView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            scene.scaleMode = .aspectFill
            scene.backgroundColor = .white
            scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0) // disable world gravity

            view.ignoresSiblingOrder = true
            #if DEBUG
            view.showsFPS = true
            view.showsNodeCount = true
            #endif

            view.presentScene(scene)
        }

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTap(_:)))
        view.addGestureRecognizer(tapRecognizer)

        setupNavbar()
    }


    // MARK: - Private -

    private func setupNavbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset".localized,
                                                                style: .done, target: self, action: #selector(onReset(_:)))
    }

    private func reloadData() {
        // add circles
        viewModel?.nodes.forEach { scene.addChild($0) }
    }

    @objc
    private func onViewTap(_ sender: UITapGestureRecognizer) {
        viewModel?.animate()
    }

    @objc
    private func onReset(_ sender: UIBarButtonItem) {
        viewModel?.resetPositions()
    }

}
