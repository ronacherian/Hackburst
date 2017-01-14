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
    @IBOutlet weak var pitchLabelValue: UILabel!
    @IBOutlet weak var rollL: UILabel!
    var captureSession:AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var myxPoint = 0.0
    var myyPoint = 0.0
    
    let xapoint = -10.0
    let yapoint = 10.0
    let zapoint = 0.0
    
    let xbpoint = -10.0
    let ybpoint = 1.0
    let zbpoint = 0.0
    
    let xcpoint = -10.0
    let ycpoint = 3.0
    let zcpoint = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        MotionManager.sharedInstance.setPedometer()
        MotionManager.sharedInstance.setGyroscpe()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.setupCameraSession()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateGyro(notification:)), name: NSNotification.Name("GYRO_UPDATE"), object: nil)

    }

    
    func updateGyro(notification:Notification) {
     
        guard let attitude = notification.object as? CMAttitude else {
            return
        }
        //self.pitchLabelValue.text = String(((attitude.pitch )/M_PI)*180)
        //self.rollL.text = String(((attitude.roll )/M_PI)*180)
        let yaByXa = self.yapoint/(self.xapoint - self.myxPoint)
        let sinInverseA = (asin(yaByXa)/M_PI)*180
        
        let ybByXb = self.ybpoint/self.xbpoint
        let sinInverseB = (asin(ybByXb)/M_PI)*180
        
        let ycByXc = self.ycpoint/self.xcpoint
        let sinInverseC = (asin(ycByXc)/M_PI)*180
        
        let yawVal = (((attitude.yaw)/M_PI)*180)
        self.countLabel.textColor = UIColor.red
        self.countLabel.backgroundColor = UIColor.clear
        if ( yawVal < sinInverseA+20 && yawVal > sinInverseA-20){
            self.countLabel.text = "FOUND A";
        } else if ( yawVal < sinInverseB+20 && yawVal > sinInverseB-20){
            self.countLabel.text = "FOUND B";
        } else if ( yawVal < sinInverseC+20 && yawVal > sinInverseC-20){
            self.countLabel.text = "FOUND C";
        }
        else {
            //self.countLabel.text = String(((attitude.yaw)/M_PI)*180)
            self.countLabel.text = "Searching..."
            self.countLabel.textColor = UIColor.blue
        }
        
        
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
    
    
    @IBAction func showDirection(_ sender: Any) {
        
    }
    
}

