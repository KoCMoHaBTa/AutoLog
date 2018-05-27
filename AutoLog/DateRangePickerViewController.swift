//
//  DateRangePickerViewController.swift
//  AutoLog
//
//  Created by Milen Halachev on 22.05.18.
//  Copyright © 2018 KoCMoHaBTa. All rights reserved.
//

import Foundation
import UIKit

class DateRangePickerViewController: UIViewController {
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.startDatePicker.date = Date().addingTimeInterval(-7200)
        self.endDatePicker.date = Date()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ActivitiesViewController {
            
            destination.start = self.startDatePicker.date
            destination.end = self.endDatePicker.date
        }
     
        if let destination = segue.destination as? DrivingActivitiesViewController {
            
            destination.start = self.startDatePicker.date
            destination.end = self.endDatePicker.date
        }
    }
}
