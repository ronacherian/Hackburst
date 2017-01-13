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
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        
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
        let startDate = Date().addingTimeInterval(-84000)
        if CMPedometer.isStepCountingAvailable() {
    
            self.corePedometer.startUpdates(from: startDate, withHandler: { (data:CMPedometerData?, error:Error?) in
              
                if let steps = data?.numberOfSteps{
                    print("STEPS = \(steps)")
                    
                    self.countLabel.text = String(describing: steps)
                }
                
            
            })

        }
    }
    
    func update() {
        
//        if let accelerometerData = motionManager.accelerometerData {
//            
//            print(accelerometerData)
//            
//        }
        
        if let gyroData = motionManager.gyroData {
            
            print(gyroData)
            
  
            
        }
        
//        if let magnetometerData = motionManager.magnetometerData {
//            
//            print(magnetometerData)
//            
//        }
//        
//        if let deviceMotion = motionManager.deviceMotion {
//            
//            print(deviceMotion)
//            
//        }
        
    }

}

