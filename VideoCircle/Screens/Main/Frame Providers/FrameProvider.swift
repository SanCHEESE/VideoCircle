//
//  FrameProvider.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 15.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import Foundation
import UIKit

/// Protocol responsible for providing frames to its delegate
protocol FrameProvider {
    var delegate: FrameProviderDelegate? { set get }
}


/// Protocol that must be implemented by classes which processes frames from FrameProvider
protocol FrameProviderDelegate: AnyObject {

    /// Called when image is captured from its source
    /// - Parameter image: image captured by FrameProvider
    func captured(image: UIImage)
}
