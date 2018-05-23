//
//  Extensions.swift
//  AutoLog
//
//  Created by Milen Halachev on 23.05.18.
//  Copyright © 2018 KoCMoHaBTa. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import ContactsUI
import CoreLocation

extension UNMutableNotificationContent {
    
    ///Creates and instance of the receiver with a given title, optional subtitle and body and default sound
    public convenience init(title: String, subtitle: String? = nil, body: String? = nil, sound: UNNotificationSound? = .default()) {
        
        self.init()
        
        self.title = title
        
        if let subtitle = subtitle {
            
            self.subtitle = subtitle
        }
        
        if let body = body {
            
            self.body = body
        }
        
        self.sound = sound
    }
    
    ///Creates and instance of the receiver with a given title, body and default sound
    public convenience init(title: String, body: String) {
        
        self.init(title: title, subtitle: nil, body: body, sound: .default())
    }
}

extension UNNotificationRequest {
    
    ///Creates and instance of the receiver with given content, UUID for identifier and nil trigger
    public convenience init(content: UNNotificationContent) {
        
        self.init(identifier: .uuid, content: content, trigger: nil)
    }
}

extension String {
    
    ///Generates a new UUID string
    public static var uuid: String {
        
        return UUID().uuidString
    }
}

extension UIApplication {
    
    ///A covenience method for performing a background task, by handling the calls to `beginBackgroundTask` and `endBackgroundTask`. You must call the competion block when done.
    public func performBackgroundTask(withName taskName: String? = nil, handler: @escaping (_ completion: @escaping () -> Void) -> Void) {
        
        let id = self.beginBackgroundTask(withName: taskName, expirationHandler: nil)
        handler {
            
            self.endBackgroundTask(id)
        }
    }
}

extension CNMutablePostalAddress {
    
    ///Creates an intance of the receiver by retrieving information from a placemark
    public convenience init(placemark: CLPlacemark) {
        
        self.init()
        
        if let street = placemark.thoroughfare {
            
            self.street = street
        }
        
        if let city = placemark.locality {
            
            self.city = city
        }
        
        if let state = placemark.administrativeArea {
            
            self.state = state
        }
        
        if let postalCode = placemark.postalCode {
            
            self.postalCode = postalCode
        }
        
        if let country = placemark.country {
            
            self.country = country
        }
        
        if let isoCountryCode = placemark.isoCountryCode {
            
            self.isoCountryCode = isoCountryCode
        }
        
        if let subAdministrativeArea = placemark.subAdministrativeArea {
            
            self.subAdministrativeArea = subAdministrativeArea
        }
        
        if let subLocality = placemark.subLocality {
            
            self.subLocality = subLocality
        }
    }
}


