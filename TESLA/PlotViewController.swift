//
//  PlotViewController.swift
//  TESLA
//
//  Created by RON CHERIAN on 14/01/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import  CoreMotion

class PlotViewController: UIViewController {

    @IBOutlet weak var myLocationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.pedometer(notification:)), name: NSNotification.Name("PEDO_UPDATE"), object: nil)

       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func pedometer(notification: Notification) -> Void {
        guard let data = notification.object as? CMPedometerData else { return  }
        
        var frame = self.myLocationView.frame
        frame.origin.x += data.distance as! CGFloat
        self.myLocationView.frame = frame
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
