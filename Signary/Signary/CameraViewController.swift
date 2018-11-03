//
//  CameraViewController.swift
//  Signary
//
//  Created by Abhinav Tirath on 11/3/18.
//  Copyright © 2018 Abhinav Tirath. All rights reserved.
//
import UIKit
import AVFoundation
class CameraViewController: UIViewController{
    @IBOutlet weak var cameraView : UIView!
    @IBOutlet weak var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
    
    
    
    
    var camera: CameraModel = CameraModel()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
    }
    //TODO: change the loading so that that ugly white screen doesn't pop up 8-4-18
    override func viewDidAppear(_ animated: Bool) {
        if let session = camera.getSession(){
            //init preview layer
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            previewLayer?.frame = self.cameraView.frame
            cameraView.layer.addSublayer(previewLayer!)
            camera.startSession()
        }else{
            fatalError()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func captureImage(){
        print(#function)
        camera.captureImage()
    }
}
extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .portrait: return .portrait
        default: return nil
        }
    }
}
