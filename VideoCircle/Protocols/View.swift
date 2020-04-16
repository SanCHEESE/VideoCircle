//
//  View.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 16.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import Foundation

/// Generic constraint for View part of MVVM
protocol View {
    associatedtype ViewModel

    var viewModel: ViewModel? { set get }
}
