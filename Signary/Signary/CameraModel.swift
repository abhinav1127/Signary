//
//  CameraModel.swift
//  Signary
//
//  Created by Ben Cradick on 11/3/18.
//  Copyright © 2018 Abhinav Tirath. All rights reserved.
//

import Foundation
import Foundation
import AVFoundation
import UIKit

class CameraModel: NSObject, AVCapturePhotoCaptureDelegate {
    var session: AVCaptureSession!
    
    var input: AVCaptureDeviceInput?
    
    var output: AVCapturePhotoOutput!
    
    var device: AVCaptureDevice?
    
    var flash: Bool = false
    
    var capturedImage : CGImage!
    
    var settings: AVCapturePhotoSettings!
    
    
    override init() {
        super.init()
        
        // lets device go to whatever is available if no back camera. Also device must be option in case device has no cameras for some reason.
        device = getDevice(position: .back) ?? AVCaptureDevice.default(for: AVMediaType.video)
        session = AVCaptureSession()
        if let device = device{
            assignInput(device: device)
        }
        
    }
    func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        print(#function)
        if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video, position: .back) {
            return device
        }
        else {
            fatalError("Missing expected back camera device.")
        }
    }
    func assignInput(device: AVCaptureDevice){
        print("\(#file):\(#function)")
        do{
            input = try AVCaptureDeviceInput(device: device)
            output = AVCapturePhotoOutput()
            
            
        }catch let error as NSError{
            print(error)
            input = nil
        }
        if let input = input{
            if(session?.canAddInput(input) == true){
                session?.addInput(input)
            }
            self.session?.beginConfiguration()
            
            self.output.isLivePhotoCaptureEnabled = output.isLivePhotoCaptureSupported
            self.output.isHighResolutionCaptureEnabled = true
            
            guard self.session.canAddOutput(self.output) else {return}
            
            self.session.sessionPreset = .photo
            self.session.addOutput(output)
            self.session.commitConfiguration()
            
            return
            
        }
    }
    func getSession()->AVCaptureSession?{
        if let session = session{
            return session
        }
        return nil
    }
    func captureImage(){
        print(#function, #file)
        
        // grab camera settings
        for formats in output.availablePhotoCodecTypes{
            print(formats)
        }
        
        settings = AVCapturePhotoSettings(format: [ kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA) ])
        settings.isAutoStillImageStabilizationEnabled = true
        settings.isHighResolutionPhotoEnabled = true
        
        getFlash(flash: flash, settings: settings)
        
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        output.capturePhoto(with: settings, delegate: self)
        print(#line)
        
    }
    func startSession(){
        session?.startRunning()
    }
    func toggleFlash(){
        flash = !flash
    }
    func getFlash(flash: Bool?, settings: AVCapturePhotoSettings){
        print(#function)
        switch(flash){
        case true:
            settings.flashMode = .on
        case false:
            settings.flashMode = .off
        default:
            settings.flashMode = .auto
        }
        
    }
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        
        
        
        print(#line)

        let currentImageOrientation = imageOrientation()
    }
    private func currentUIOrientation() -> UIDeviceOrientation {
        let deviceOrientation: UIDeviceOrientation = { () -> UIDeviceOrientation in
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:
                return .landscapeRight
            case .landscapeRight:
                return .landscapeLeft
            case .portraitUpsideDown:
                return .portraitUpsideDown
            case .portrait, .unknown:
                return .portrait
                
            }
        }()
        return deviceOrientation
    }
    private func  imageOrientation(
        fromDevicePosition devicePosition: AVCaptureDevice.Position = .back
        ) -> UIImageOrientation {
        var deviceOrientation = UIDevice.current.orientation
        if deviceOrientation == .faceDown || deviceOrientation == .faceUp ||
            deviceOrientation == .unknown {
            deviceOrientation = currentUIOrientation()
        }
        switch deviceOrientation {
        case .portrait:
            return devicePosition == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return devicePosition == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return devicePosition == .front ? .rightMirrored : .left
        case .landscapeRight:
            return devicePosition == .front ? .upMirrored : .down
        case .faceDown, .faceUp, .unknown:
            return .up
        }
    }
}
