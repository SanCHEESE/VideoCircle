//
//  ViewModel.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 16.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import Foundation

/// A generic constraint for ViewModel entities
protocol ViewModel {
    associatedtype Coordinator

    /// Associated coordinator
    var coordinator: Coordinator { get }

    /// Initializer
    /// - Parameter coordinator: module/screen coordinator
    init(coordinator: Coordinator)
}
