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
    
    let significantLocationsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("significantLocations", isDirectory: false).appendingPathExtension("plist").path
    let visitsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("visits", isDirectory: false).appendingPathExtension("plist").path
    
    func save() {
        
        let significantLocationsSuccess = NSKeyedArchiver.archiveRootObject(self.significantLocations, toFile: self.significantLocationsPath)
        print("save significantLocations: \(significantLocationsSuccess)")
        
        let visitsSuccess = NSKeyedArchiver.archiveRootObject(self.visits, toFile: self.visitsPath)
        print("save visits: \(visitsSuccess)")
    }
    
    func load() {
        
        self.significantLocations = NSKeyedUnarchiver.unarchiveObject(withFile: self.significantLocationsPath) as? [Location] ?? []
        self.visits = NSKeyedUnarchiver.unarchiveObject(withFile: self.visitsPath) as? [Visit] ?? []
    }
}

class Location: NSObject, NSCoding {
    
    let location: CLLocation
    let placemark: CLPlacemark
    let address: String
    
    init(location: CLLocation, placemark: CLPlacemark, address: String) {
        
        self.location = location
        self.placemark = placemark
        self.address = address
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.location, forKey: "location")
        aCoder.encode(self.placemark, forKey: "placemark")
        aCoder.encode(self.address, forKey: "address")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard
        let location = aDecoder.decodeObject(forKey: "location") as? CLLocation,
        let placemark = aDecoder.decodeObject(forKey: "placemark") as? CLPlacemark,
        let address = aDecoder.decodeObject(forKey: "address") as? String
        else {
            
            return nil
        }
        
        self.init(location: location, placemark: placemark, address: address)
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

class Visit: NSObject, NSCoding {
    
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
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.visit, forKey: "visit")
        aCoder.encode(self.location, forKey: "location")
        aCoder.encode(self.placemark, forKey: "placemark")
        aCoder.encode(self.address, forKey: "address")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard
        let visit = aDecoder.decodeObject(forKey: "visit") as? CLVisit,
        let location = aDecoder.decodeObject(forKey: "location") as? CLLocation,
        let placemark = aDecoder.decodeObject(forKey: "placemark") as? CLPlacemark,
        let address = aDecoder.decodeObject(forKey: "address") as? String
        else {
            
            return nil
        }
        
        self.init(visit: visit, location: location, placemark: placemark, address: address)
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
