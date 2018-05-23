//
//  Storage.swift
//  AutoLog
//
//  Created by Milen Halachev on 23.05.18.
//  Copyright © 2018 KoCMoHaBTa. All rights reserved.
//

import Foundation
import CoreLocation
import ContactsUI

class Storage {
    
    var significantLocations: [Location] = [] {
        
        didSet {
            
            self.save()
        }
    }
    
    var visits: [Visit] = [] {
        
        didSet {
            
            self.save()
        }
    }
    
    static let shared = Storage()
    
    init() {
        
        self.load()
    }
    
    func save() {
        
    }
    
    func load() {
        
    }
}

class Location {
    
    let location: CLLocation
    let placemark: CLPlacemark
    let address: String
    
    init(location: CLLocation, placemark: CLPlacemark, address: String) {
        
        self.location = location
        self.placemark = placemark
        self.address = address
    }
    
    static func makeWith(location: CLLocation, completion: @escaping (Location?) -> Void) {
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            
            guard let placemark = placemarks?.first else {
                
                completion(nil)
                return
            }
            
            let address = CNPostalAddressFormatter.string(from: CNMutablePostalAddress(placemark: placemark), style: .mailingAddress)
            
            let result = Location(location: location, placemark: placemark, address: address)
            completion(result)
        }
    }
}

class Visit {
    
    let visit: CLVisit
    let location: CLLocation
    let placemark: CLPlacemark
    let address: String
    
    init(visit: CLVisit, location: CLLocation, placemark: CLPlacemark, address: String) {
        
        self.visit = visit
        self.location = location
        self.placemark = placemark
        self.address = address
    }
    
    static func makeWith(visit: CLVisit, completion: @escaping (Visit?) -> Void) {
        
        let location = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            
            guard let placemark = placemarks?.first else {
                
                completion(nil)
                return
            }
            
            let address = CNPostalAddressFormatter.string(from: CNMutablePostalAddress(placemark: placemark), style: .mailingAddress)
            
            let result = Visit(visit: visit, location: location, placemark: placemark, address: address)
            completion(result)
        }
    }
}
