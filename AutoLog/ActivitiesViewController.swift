//
//  ActivitiesViewController.swift
//  AutoLog
//
//  Created by Milen Halachev on 22.05.18.
//  Copyright © 2018 KoCMoHaBTa. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class ActivitiesViewController: UITableViewController {
    
    var fromDate: Date!
    var toDate: Date!
    
    let motionActivityManager = CMMotionActivityManager()
    var activities: [CMMotionActivity] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.motionActivityManager.queryActivityStarting(from: self.fromDate, to: self.toDate, to: .main) { (activities, error) in
            
            self.activities = activities ?? []
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! ActivityCell
        
        let activity = self.activities[indexPath.row]
        cell.configure(wtih: activity)
        
        return cell
    }
}

class ActivityCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    @IBOutlet weak var stationaryImageView: UIImageView!
    @IBOutlet weak var walkingImageView: UIImageView!
    @IBOutlet weak var runningImageView: UIImageView!
    @IBOutlet weak var automotiveImageView: UIImageView!
    @IBOutlet weak var cylcingImageView: UIImageView!
    @IBOutlet weak var unknownImageView: UIImageView!
    
    func configure(wtih activity: CMMotionActivity) {
        
        self.dateLabel.text = activity.startDate.description
        
        switch activity.confidence {
            
            case .high:
                self.confidenceLabel.text = "high"
            
            case .low:
                self.confidenceLabel.text = "low"
            
            case .medium:
                self.confidenceLabel.text = "medium"
        }
        
        self.stationaryImageView.isHidden = !activity.stationary
        self.walkingImageView.isHidden = !activity.walking
        self.runningImageView.isHidden = !activity.running
        self.automotiveImageView.isHidden = !activity.automotive
        self.cylcingImageView.isHidden = !activity.cycling
        self.unknownImageView.isHidden = !activity.unknown
    }
}
