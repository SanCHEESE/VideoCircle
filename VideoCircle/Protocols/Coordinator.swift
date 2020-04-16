//
//  Coordinator.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 16.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import Foundation
import UIKit

// Protocol to be implemented by coordinators. Coordinator is an entity that manages single screen navigation
protocol Coordinator {

    var navigationController: UINavigationController { get }

    /// Initializer
    /// - Parameter navigationController: navigation controller
    init(navigationController: UINavigationController)

    /// Shows screen (module)
    func start()
}
