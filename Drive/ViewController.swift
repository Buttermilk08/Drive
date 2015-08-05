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

class ViewController: UIViewController {
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var accelerationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Location Stuff
        // TODO: check the kCLAuthorizationStatus
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Motion Stuff
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

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        let speedInMetersPerSecond = location.speed
        let speedInMilesPerHour = speedInMetersPerSecond * METERS_PER_SECOND_TO_MILES_PER_HOUR
        speedLabel.text = String(format: "%02.0f", arguments: [speedInMilesPerHour])
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: \(error.description)")
    }
}

