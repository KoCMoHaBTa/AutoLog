//
//  ViewController.swift
//  AutoLog
//
//  Created by Milen Halachev on 11.05.18.
//  Copyright © 2018 KoCMoHaBTa. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import UserNotifications
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    let locationManager = CLLocationManager()
//    let motionManager = CMMotionManager()
    
    let motionActivityManager = CMMotionActivityManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.label.text = "0km"
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.startMonitoringSignificantLocationChanges()
//        self.locationManager.activityType = .
//        self.locationManager.pausesLocationUpdatesAutomatically = false
        
    }
    
    @IBAction func testLocalNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "test local notification"
        content.subtitle = "gg"
        content.body = "vui"
        content.sound = .default()
        
        let request = UNNotificationRequest(identifier: "testLocalNotification", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            
            return
        }
        
        var id = UIApplication.shared.beginBackgroundTask(withName: "locationUpdate")
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            
            guard let placemark = placemarks?.first else {
                
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = "didUpdateLocations \(locations.count)"
            content.body = placemark.description
            
            content.sound = .default()
            
            let request = UNNotificationRequest(identifier: "didUpdateLocations", content: content, trigger: nil)
            
            UNUserNotificationCenter.current().add(request) { error in
                
                UIApplication.shared.endBackgroundTask(id)
                id = UIBackgroundTaskInvalid
            }
        }
    }
}

