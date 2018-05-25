//
//  VisitsViewController.swift
//  AutoLog
//
//  Created by Milen Halachev on 23.05.18.
//  Copyright © 2018 KoCMoHaBTa. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class VisitsViewController: UITableViewController {
    
    var visits: [Visit] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! MapViewController
        
        if let cell = sender as? UITableViewCell, let indexPath = self.tableView.indexPath(for: cell) {
            
            let visit = self.visits[indexPath.row]
            destination.points = [visit]
        }
        
        if sender is UIBarButtonItem {
            
            destination.points = self.visits
        }
    }
    
    private func loadData() {
        
        self.visits = Storage.shared.visits
        self.tableView.reloadData()
    }
    
    //MARK: - UITableViewDataSource & UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.visits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        
        let visit = self.visits[indexPath.row]
        cell.configure(with: visit)
        
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
    
    func configure(with visit: Visit) {
        
        self.textLabel?.text = visit.address
        self.detailTextLabel?.text = "\(type(of: self).dateFormatter.string(from: visit.visit.arrivalDate)) - \(type(of: self).dateFormatter.string(from: visit.visit.departureDate))"
        
    }
}

