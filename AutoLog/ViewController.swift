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
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            
            return
        }
        
        UIApplication.shared.performBackgroundTask { (completion) in
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                
                guard let placemark = placemarks?.first else {
                    
                    return
                }
                
                let address = CNPostalAddressFormatter.string(from: CNMutablePostalAddress(placemark: placemark), style: .mailingAddress)
                
                let content = UNMutableNotificationContent(title: "didUpdateLocations", body: address)
                let request = UNNotificationRequest(content: content)
                UNUserNotificationCenter.current().add(request) { error in
                    
                    completion()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        
        UIApplication.shared.performBackgroundTask { (completion) in
            
            let location = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                
                guard let placemark = placemarks?.first else {
                    
                    return
                }
                
                let address = CNPostalAddressFormatter.string(from: CNMutablePostalAddress(placemark: placemark), style: .mailingAddress)
                
                let content = UNMutableNotificationContent(title: "didVisit", body: address)
                let request = UNNotificationRequest(content: content)
                UNUserNotificationCenter.current().add(request) { error in
                    
                    completion()
                }
            }
        }
        
        
    }
}

