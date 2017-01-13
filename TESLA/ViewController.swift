//
//  ViewController.swift
//  TESLA
//
//  Created by Oldrin Mendez on 13/01/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var countLabel: UILabel!
    var captureSession:AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var corePedometer:CMPedometer = CMPedometer()
    var motionManager: CMMotionManager!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.setupCameraSession()
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startDeviceMotionUpdates()
        
        let queue = OperationQueue()
        
        motionManager.startGyroUpdates(to: queue) { (data:CMGyroData?, error:Error?) in
            
            DispatchQueue.main.async {
                
//                print(self.motionManager.deviceMotion?.attitude.roll ?? 0.0)
                print(self.motionManager.deviceMotion?.attitude.quaternion ?? 0.0)
//                print(self.motionManager.deviceMotion?.attitude.yaw ?? 0.0)
            }
            
        }
        
        setPedometer()

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func setupCameraSession() {
        
        self.captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        if let input = try? AVCaptureDeviceInput(device: backCamera) {
            
            self.captureSession.addInput(input)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        
        self.previewLayer.frame = self.cameraView.bounds
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
        
        cameraView.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
    }
    
    func setPedometer(){
        let startDate = Date()
        if CMPedometer.isStepCountingAvailable() {
    
            self.corePedometer.startUpdates(from: startDate, withHandler: { (data:CMPedometerData?, error:Error?) in
              
                if let steps = data?.numberOfSteps{
                    
                    DispatchQueue.main.async {
                        self.countLabel.text = String(describing: steps)
                    }
                    
                    
                    print("STEPS = \(steps)")
                    
                    
                }
                
            
            })

        }
    }
    
}

