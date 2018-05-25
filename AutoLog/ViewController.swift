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
import ContactsUI

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    let locationManager = CLLocationManager()
//    let motionManager = CMMotionManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.label.text = "0km"
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.startMonitoringVisits()
//        self.locationManager.activityType = .
//        self.locationManager.pausesLocationUpdatesAutomatically = false
        
    }
    
    @IBAction func testLocalNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "test local notification"
        content.subtitle = "gg"
        content.body = "vui"
        content.sound = .default()
        
        
        let request = UNNotificationRequest(identifier: .uuid, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    @IBAction func deleteAllLocations() {
        
        Storage.shared.significantLocations = []
    }
    
    @IBAction func deleteAllVisits() {
        
        Storage.shared.visits = []
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            
            return
        }
    
        UIApplication.shared.performBackgroundTask { (completion) in
            
            Location.makeWith(location: location) { (location) in
                
                guard let location = location else {
                    
                    completion()
                    return
                }
                
                Storage.shared.significantLocations.append(location)
                
                let content = UNMutableNotificationContent(title: "didUpdateLocations", body: location.address)
                let request = UNNotificationRequest(content: content)
                UNUserNotificationCenter.current().add(request) { error in
                    
                    completion()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
                
        UIApplication.shared.performBackgroundTask { (completion) in
            
            Visit.makeWith(visit: visit, completion: { (visit) in
                
                guard let visit = visit else {
                    
                    completion()
                    return
                }
                
                Storage.shared.visits.append(visit)
                
                let content = UNMutableNotificationContent(title: "didVisit", body: visit.address)
                let request = UNNotificationRequest(content: content)
                UNUserNotificationCenter.current().add(request) { error in
                    
                    completion()
                }
            })
        }
    }
}

