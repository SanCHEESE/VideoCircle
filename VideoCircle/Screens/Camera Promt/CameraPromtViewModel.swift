//
//  CameraPromtViewModel.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 16.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import AVFoundation

enum CameraPromtMode {
    case restricted
    case notDetermined
}

final class CameraPromtViewModel: ViewModel {
    typealias Coordinator = CameraPromtCoordinator

    // MARK: - ViewModel protocol -

    let coordinator: Coordinator

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Properties -

    var promtMode: CameraPromtMode {
        get {
            switch authStatus {
            case .denied, .restricted:
                return .restricted
            case .notDetermined:
                return .notDetermined
            default:
                fatalError("Auth status is incorrect")
            }
        }
    }
    var onCameraProhibited: ()->() = {}

    var authStatus: AVAuthorizationStatus?

    // MARK: - Public methods -

    func goToSettings() {
        coordinator.goToSettings()
    }

    func checkPermission() {
        authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            DispatchQueue.main.async {
                self.coordinator.goToMain()
            }
        default: // do nothing
            break
        }
    }

    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            DispatchQueue.main.async {
                if granted {
                    self.coordinator.goToMain()
                } else {
                    self.authStatus = AVCaptureDevice.authorizationStatus(for: .video)
                    self.onCameraProhibited()
                }
            }
        }
    }
    
}
