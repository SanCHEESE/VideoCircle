//
//  ImageCropper.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 16.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import UIKit

/// Image cropper
protocol ImageCropper {

    /// Crop image
    /// - Parameters:
    ///   - image: image to crop
    ///   - completion: completion handler
    func crop(image: UIImage, _ completion: @escaping (UIImage?)->())
}

/// Cropper for UIImage that creates squared image
final class SquareImageCropper: ImageCropper {

    var cropSize: CGSize {
        didSet {
            assert(cropSize.width == cropSize.height, "Crop size must be squared!")
        }
    }

    /// Queue for resizing
    let queue = DispatchQueue(label: "com.ab.videoCircle.resize")

    init(cropSize: CGSize) {
        self.cropSize = cropSize
    }

    func crop(image: UIImage, _ completion: @escaping (UIImage?) -> () = { _ in }) {
        queue.async {
            completion(self.getCroppedImage(from: image))
        }
    }

    private func getCroppedImage(from image: UIImage) -> UIImage? {

        // FIXME: DUMB WAY!, better to use single context
        let cgimage = image.cgImage!
        let imageSize: CGSize = image.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let sideSize: CGFloat = min(imageSize.width, imageSize.height)

        // See what size is longer and create the center off of that
        if imageSize.width > imageSize.height {
            posX = ((imageSize.width - imageSize.height) / 2)
            posY = 0
        } else {
            posX = 0
            posY = ((imageSize.height - imageSize.width) / 2)
        }

        // Create square image from center of rectangular image
        let rect: CGRect = CGRect(x: posX, y: posY, width: sideSize, height: sideSize)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let croppedImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

        // Resize UIImage to crop size
        UIGraphicsBeginImageContextWithOptions(cropSize, false, 0.0)
        croppedImage.draw(in: CGRect(origin: .zero, size: cropSize))
        let result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return result
    }
}
