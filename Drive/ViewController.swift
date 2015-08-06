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

let METERS_PER_SECOND_TO_MILES_PER_HOUR = 2.236
let ACCELERATION_DUE_TO_GRAVITY = 9.806

class ViewController: UIViewController {
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var accelerationLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Location Stuff
        // TODO: check the kCLAuthorizationStatus
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Motion Stuff
//        let motionManager = AppDelegate.Motion.Manager
//        motionManager.accelerometerUpdateInterval = 0.2
//        
//        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler:{(accelerometerData, error) -> Void in
//            self.outputAccelerationData(accelerometerData.acceleration)})
        
        
        let motionManager = AppDelegate.Motion.Manager
        motionManager.deviceMotionUpdateInterval = 0.5
        
        if motionManager.deviceMotionAvailable {
            if motionManager.deviceMotionActive == false {
            motionManager.startDeviceMotionUpdates()
                self.outputAccelerationData(motionManager.deviceMotion)
                
            } else {
                motionManager.stopDeviceMotionUpdates()
            }
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func outputAccelerationData(acceleration:CMDeviceMotion){
        println(acceleration.description)
        println(acceleration.userAcceleration)
        //self.accelerationLabel.text = String(format: "%.2f", acceleration.)
        
    }
}
//    func outputAccelerationData(acceleration:CMDeviceMotion){
//        var totalAcceleration = (sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z) - 1.0) * ACCELERATION_DUE_TO_GRAVITY
//        
//        self.accelerationLabel.text = String(format: "%.2f", totalAcceleration)
//        
//    }
//}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        let speedInMetersPerSecond = max(location.speed, 0)
        let speedInMilesPerHour = Int(speedInMetersPerSecond * METERS_PER_SECOND_TO_MILES_PER_HOUR)
        speedLabel.text = String(speedInMilesPerHour)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: \(error.description)")
    }
}

