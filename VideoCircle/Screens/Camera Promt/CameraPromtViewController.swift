//
//  CameraPromtViewController.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 16.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit
import AVFoundation

/// Camera promt view
final class CameraPromtViewController: UIViewController, View {
    typealias ViewModel = CameraPromtViewModel

    // MARK: - View Protocol -
    
    var viewModel: ViewModel? {
        didSet {
            reloadView()
            viewModel?.onCameraProhibited = { [weak self] in
                self?.reloadView()
            }
        }
    }

    // MARK: - Subviews -

    private lazy var promtLabel: UILabel = {
        return label(with: "To continue, app requires access to camera".localized)
    }()

    private lazy var goToSettingsLabel: UILabel = {
        return label(with: "Please, allow camera usage in settings".localized)
    }()

    private lazy var goToSettingsButton: UIButton = {
        return button(with: "Go to Settings".localized, selector: #selector(goToSettings(_:)))
    }()

    private lazy var grantCameraAccessButton: UIButton = {
        return button(with: "Grant access".localized, selector: #selector(requestCameraPermission(_:)))
    }()

    // MARK: - ViewController lifecycle - 

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Camera promts".localized

        setupSubviews()
        makeConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // when returned from settings
        viewModel?.checkPermission()
    }

    // MARK: - Private methods -

    private func reloadView() {
        switch viewModel?.promtMode {
        case .notDetermined:
            goToSettingsLabel.isHidden = true
            goToSettingsButton.isHidden = true
            promtLabel.isHidden = false
            grantCameraAccessButton.isHidden = false
        case .restricted:
            promtLabel.isHidden = true
            goToSettingsLabel.isHidden = false
            goToSettingsButton.isHidden = false
            grantCameraAccessButton.isHidden = true
        default:
            break
        }
    }

    private func setupSubviews() {
        view.addSubview(promtLabel)
        view.addSubview(goToSettingsLabel)
        view.addSubview(goToSettingsButton)
        view.addSubview(grantCameraAccessButton)
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            promtLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            promtLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            promtLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])

        NSLayoutConstraint.activate([
            goToSettingsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            goToSettingsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            goToSettingsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])

        NSLayoutConstraint.activate([
            goToSettingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToSettingsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            goToSettingsButton.widthAnchor.constraint(equalToConstant: 200),
            goToSettingsButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            grantCameraAccessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            grantCameraAccessButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            grantCameraAccessButton.widthAnchor.constraint(equalToConstant: 200),
            grantCameraAccessButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }


    @objc
    private func requestCameraPermission(_ sender: UIButton) {
        viewModel?.requestPermission()
    }

    @objc
    private func goToSettings(_ sender: UIButton) {
        viewModel?.goToSettings()
    }

    private func label(with title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }

    private func button(with title: String, selector: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
}
