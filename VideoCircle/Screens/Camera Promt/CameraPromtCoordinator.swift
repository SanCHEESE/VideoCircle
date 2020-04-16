//
//  CameraPromtCoordinator.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 16.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

/// Camera promt screen coordinator
final class CameraPromtCoordinator: Coordinator {

    // MARK: - Coordinator protocol -
    
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // check camera permission
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            goToMain()
        default:
            let viewController = CameraPromtViewController()
            let viewModel = CameraPromtViewModel(coordinator: self)
            viewModel.authStatus = authStatus
            viewController.viewModel = viewModel
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func goToMain() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.start()
    }

    func goToSettings() {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}
