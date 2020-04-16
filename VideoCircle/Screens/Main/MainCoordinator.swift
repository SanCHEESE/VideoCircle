//
//  MainCoordinator.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 16.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import Foundation
import UIKit

/// Coordinator for Main screen
final class MainCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = MainViewController()
        viewController.viewModel = MainViewModel(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
