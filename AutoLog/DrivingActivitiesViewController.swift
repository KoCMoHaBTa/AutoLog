//
//  DrivingActivitiesViewController.swift
//  AutoLog
//
//  Created by Milen Halachev on 27.05.18.
//  Copyright © 2018 KoCMoHaBTa. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import CoreMotion

class DrivingActivitiesViewController: UITableViewController {
    
    var start: Date!
    var end: Date!
    
    var activities: [DrivingActivity] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.loadData()
    }
    
    private func loadData() {
        
        DrivingActivity.load(from: self.start, to: self.end) { [weak self] (activities) in
            
            self?.activities = activities
            self?.tableView.reloadData()
        }
    }
    
    //MARK: - UITableViewDataSource & UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        
        let activity = self.activities[indexPath.row]
        cell.configure(with: activity)
        
        return cell
    }
}

extension UITableViewCell {
    
    private static let dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }()
    
    func configure(with activity: DrivingActivity) {
        
        self.textLabel?.text = "\(type(of: self).dateFormatter.string(from: activity.start)) - \(type(of: self).dateFormatter.string(from: activity.end))"
        self.detailTextLabel?.text = activity.locations.reduce("", { $0 + "\($1.kind.abbreviation): " + $1.address + "\n---------------\n" })
    }
}

class DrivingActivity {
    
    let start: Date
    let end: Date
    private(set) var locations: [DrivingLocation]
    
    init(from start: Date, to end: Date, locations: [DrivingLocation]) {
        
        self.start = start
        self.end = end
        self.locations = locations
    }
    
    static func load(from start: Date, to end: Date, completion: @escaping ([DrivingActivity]) -> Void) {
        
        CMMotionActivityManager().queryActivityStarting(from: start, to: end, to: .main) { (activities, error) in
            
            //driving is considered all activites between activity with state `automotive` == true and activity with state `walking` == true
            var isDriving = false
            var result: [DrivingActivity] = []
            
            var start: Date! = nil
            
            for activity in activities ?? [] {
                
                //if we are not driving - look for activity with `automotive` == true in order to start driving, otherwise skip this activity
                if isDriving == false {
                    
                    if activity.automotive == true {
                        
                        isDriving = true
                        start = activity.startDate
                        continue
                    }
                    else {
                        
                        continue
                    }
                }
                
                //if we are driving - look for activity with `walking` == true in order to stop driving, otherwise add this activity to the result
                if isDriving == true {
                    
                    if activity.walking == true {
                        
                        isDriving = false
                        let end = activity.startDate
                        result.append(DrivingActivity(from: start, to: end, locations: []))
                        start = nil
                        continue
                    }
                }
            }
            
            //retrieve driving locations for each activity
            result.forEach({ (activity) in
                
                activity.locations = DrivingLocation.load(from: activity.start, to: activity.end)
            })
            
            completion(result)
        }
    }
}

class DrivingLocation: NSObject, MKAnnotation {
    
    enum Kind {
        
        case location
        case visit
        
        var abbreviation: String {
            
            switch self {
                
                case .location:
                    return "L"
                case .visit:
                    return "V"
            }
        }
    }
    
    let location: CLLocation
    let placemark: CLPlacemark
    let address: String
    let timestamp: Date
    let kind: Kind
    
    init(location: CLLocation, placemark: CLPlacemark, address: String, timestamp: Date, kind: Kind) {
        
        self.location = location
        self.placemark = placemark
        self.address = address
        self.timestamp = timestamp
        self.kind = kind
    }
    
    //MARK: - MKAnnotation
    
    var coordinate: CLLocationCoordinate2D {
        
        return self.location.coordinate
    }
    
    var title: String? {
        
        return self.address
    }
    
    var subtitle: String? {
        
        return nil
    }
    
    static func load(from start: Date, to end: Date, threshold: TimeInterval = 600) -> [DrivingLocation] {
        
        //adjust dates according to threshold
        let start = start.addingTimeInterval(-threshold)
        let end = end.addingTimeInterval(threshold)
        
        func isDateWithingRange(date: Date) -> Bool {
            
            guard date != .distantPast && date != .distantFuture else {
                
                return false
            }
            
            let result = start < date && date < end
            return result
        }
        
        var result: [DrivingLocation] = []
        
        //load locations within the start and end date
        result += Storage.shared.significantLocations.reduce([], { (result, location) -> [DrivingLocation] in
            
            var result = result
            
            if isDateWithingRange(date: location.location.timestamp) && !result.contains(where: { $0.timestamp == location.location.timestamp }) {
                
                result.append(DrivingLocation(location: location.location, placemark: location.placemark, address: location.address, timestamp: location.location.timestamp, kind: .location))
            }
            
            return result
        })
        
        //load visits within the start and end date
        result += Storage.shared.visits.reduce([], { (result, visit) -> [DrivingLocation] in
            
            var result = result
            
            if isDateWithingRange(date: visit.visit.arrivalDate) && !result.contains(where: { $0.timestamp == visit.visit.arrivalDate }) {
                
                result.append(DrivingLocation(location: visit.location, placemark: visit.placemark, address: visit.address, timestamp: visit.visit.arrivalDate, kind: .visit))
            }
            else if isDateWithingRange(date: visit.visit.departureDate) && !result.contains(where: { $0.timestamp == visit.visit.departureDate }) {
                
                result.append(DrivingLocation(location: visit.location, placemark: visit.placemark, address: visit.address, timestamp: visit.visit.departureDate, kind: .visit))
            }
            
            return result
        })
        
        result.sort(by: { $0.timestamp < $1.timestamp })
        
        return result
    }
}
