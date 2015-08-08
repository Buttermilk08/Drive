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
var maxAcceleration = 0.00

class ViewController: UIViewController {
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var accelerationLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // **** Location Stuff ****
        // TODO: check the kCLAuthorizationStatus
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // **** Motion Stuff ****
//        let motionManager = CMMotionActivityManager()
        // What is the difference between CMMotionManager and CMMotionActivityManager????
//        let motionManager = CMMotionManager()
//        if motionManager.deviceMotionAvailable {
//            motionManager.deviceMotionUpdateInterval = 0.2
//            
//            let queue = NSOperationQueue()
//            motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryCorrectedZVertical, toQueue: queue, withHandler: {(accelerometerData, error) -> Void in
////            motionManager.startDeviceMotionUpdatesToQueue(queue) {
////                [weak self] (data: CMDeviceMotion!, error: NSError!) in
//            
//                var x = accelerometerData.userAcceleration.x
//                var y = accelerometerData.userAcceleration.y
//                var z = accelerometerData.userAcceleration.z
//                println(x)
//                println(y)
//                println(z)
//                // motion processing here
//                var totalAcceleration = (sqrt(x * x + y * y + z * z) - 1.0) * ACCELERATION_DUE_TO_GRAVITY
//                
//                NSOperationQueue.mainQueue().addOperationWithBlock {
//                    // update UI here
//                    //self.accelerationLabel.text = String(stringInterpolationSegment: totalAcceleration)
//                    println(totalAcceleration)
//
//                }
//            })
//        }
        
        
    }
    
     override func viewDidAppear(animated: Bool) {
            
        let motionManager = AppDelegate.Motion.Manager
        motionManager.accelerometerUpdateInterval = 0.2
            
        if motionManager.accelerometerAvailable {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: {(accelerometerData, error) -> Void in
                self.outputAccelerationData(accelerometerData.acceleration)})
        }
            
     }
        
     override func viewDidDisappear(animated: Bool) {
        AppDelegate.Motion.Manager.stopDeviceMotionUpdates()
     }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func outputAccelerationData(acceleration:CMAcceleration){
        var newAcceleration = (sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z) - 1.0) * ACCELERATION_DUE_TO_GRAVITY
        
        if maxAcceleration < newAcceleration {
            maxAcceleration = newAcceleration
        }
    
        self.accelerationLabel.text = String(format: "%.2f", maxAcceleration)
        
    }
}

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

