//
//  SignificantLocationsViewController.swift
//  AutoLog
//
//  Created by Milen Halachev on 23.05.18.
//  Copyright © 2018 KoCMoHaBTa. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class SignificantLocationsViewController: UITableViewController {
    
    var locations: [Location] = []
    
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
            
            let location = self.locations[indexPath.row]
            destination.points = [location]
        }
        
        if sender is UIBarButtonItem {
            
            destination.points = self.locations
        }
    }
    
    private func loadData() {
        
        self.locations = Storage.shared.significantLocations
        self.tableView.reloadData()
    }
    
    //MARK: - UITableViewDataSource & UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        
        let location = self.locations[indexPath.row]
        cell.configure(with: location)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            self.locations.remove(at: indexPath.row)
            Storage.shared.significantLocations = self.locations
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension UITableViewCell {
    
    private static let dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }()
    
    func configure(with location: Location) {
        
        self.textLabel?.text = location.address
        self.detailTextLabel?.text = type(of: self).dateFormatter.string(from: location.location.timestamp)
    }
}
