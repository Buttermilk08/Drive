//
//  ViewController.swift
//  Drive
//
//  Created by Patrick Corrigan on 8/5/15.
//  Copyright (c) 2015 Gold Slash. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var accelerationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let motionManager = AppDelegate.Motion.Manager
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.gyroUpdateInterval = 0.2
        
        if motionManager.accelerometerAvailable {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: {(accelerometerData, error) -> Void in
                self.outputAccelerationData(accelerometerData.acceleration)})
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func outputAccelerationData(acceleration:CMAcceleration){
        var totalAcceleration = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)
        
        self.accelerationLabel.text = String(format: "%.2f", totalAcceleration)
        
    }
    
   
    
    
}

