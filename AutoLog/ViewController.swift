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

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
//    let locationManager = CLLocationManager()
//    let motionManager = CMMotionManager()
    
    let motionActivityManager = CMMotionActivityManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.label.text = "0km"
        
//        let start = Date(timeIntervalSinceNow: -86400)
//        let end = Date()
        
//        self.motionActivityManager.queryActivityStarting(from: start, to: end, to: .main) { (activities, error) in
//
//            print(activities?.count)
//        }
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

