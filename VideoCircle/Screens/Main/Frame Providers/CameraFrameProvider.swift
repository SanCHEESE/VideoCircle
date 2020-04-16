//
//  CameraFrameProvider.swift
//  VideoCircle
//
//  Created by Alexander Bochkarev on 15.04.2020.
//  Copyright © 2020 AB. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

/// Provider for frames from camera
final class CameraFrameProvider: NSObject, FrameProvider {
    weak var delegate: FrameProviderDelegate?
    var imageCropper: ImageCropper?

    private let position = AVCaptureDevice.Position.front
    private let quality = AVCaptureSession.Preset.high
    static private let queueLabel = "com.ab.videoCapture.camera"

    private let sessionQueue = DispatchQueue(label: queueLabel)
    private let captureSession = AVCaptureSession()
    private let context = CIContext()

    override init() {
        super.init()

        checkPermission()

        sessionQueue.async { [unowned self] in
            self.configureSession()
            self.captureSession.startRunning()
        }
    }

    // MARK: - Private methods -

    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        default:
            fatalError("Permission should be asked before creating CameraFrameProvider")
        }
    }

    private func configureSession() {
        captureSession.sessionPreset = quality
        guard let captureDevice = selectCaptureDevice() else { return }
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        guard captureSession.canAddInput(captureDeviceInput) else { return }
        captureSession.addInput(captureDeviceInput)
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
        guard let connection = videoOutput.connection(with: .video) else { return }
        guard connection.isVideoOrientationSupported else { return }
        guard connection.isVideoMirroringSupported else { return }
        connection.videoOrientation = .portrait
        connection.isVideoMirrored = position == .front
        connection.preferredVideoStabilizationMode = .off
    }

    private func selectCaptureDevice() -> AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: self.position)
    }

    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

}

extension CameraFrameProvider: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let sampleBufferImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }

        // resize image
        imageCropper?.crop(image: sampleBufferImage) { [unowned self] image in
            self.delegate?.captured(image: image ?? sampleBufferImage)
        }
    }
}
