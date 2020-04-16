//
//  AppCoordinator.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 16.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {

    let navigationController: UINavigationController

    func start() {
        let cameraPromtCoordinator = CameraPromtCoordinator(navigationController: navigationController)
        cameraPromtCoordinator.start()
    }


    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}
