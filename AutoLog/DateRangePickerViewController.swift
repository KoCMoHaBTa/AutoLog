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
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! ActivitiesViewController
        destination.fromDate = self.fromDatePicker.date
        destination.toDate = self.toDatePicker.date
    }
}
