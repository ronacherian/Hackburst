//
//  MotionManager.swift
//  TESLA
//
//  Created by RON CHERIAN on 14/01/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import CoreMotion

class MotionManager: NSObject {
    
    static let sharedInstance = MotionManager()

    var corePedometer:CMPedometer = CMPedometer()
    var motionManager: CMMotionManager!

    var myxPoint = 0.0
    var myyPoint = 0.0
    
    func setGyroscpe() {
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startDeviceMotionUpdates()
        
        let queue = OperationQueue()
        
        motionManager.startGyroUpdates(to: queue) { (data:CMGyroData?, error:Error?) in
            
            DispatchQueue.main.async {
                
                NotificationCenter.default.post(name: NSNotification.Name("GYRO_UPDATE"), object: self.motionManager.deviceMotion?.attitude)
                
                              
                print(self.motionManager.deviceMotion?.attitude.roll ?? 0.0)
                print(((self.motionManager.deviceMotion?.attitude.roll ?? 0.0)/180.0)*M_PI)
                
                //                print(self.motionManager.deviceMotion?.attitude.yaw ?? 0.0)
            }
            
        }
        
        setPedometer()
    }
    func setPedometer(){
        let startDate = Date()
        if CMPedometer.isStepCountingAvailable() {
            
            self.corePedometer.startUpdates(from: startDate, withHandler: { (data:CMPedometerData?, error:Error?) in
                
                if let steps = data?.numberOfSteps{
                    
                    DispatchQueue.main.async {
                        //self.countLabel.text = String(describing: steps)
                        self.myxPoint = self.myxPoint +  Double(steps)
                        NotificationCenter.default.post(name: NSNotification.Name("PEDO_UPDATE"), object: data)

                    }
                    
                    
                    print("STEPS = \(steps)")
                    
                    
                }
                
                
            })
            
        }
    }
}
