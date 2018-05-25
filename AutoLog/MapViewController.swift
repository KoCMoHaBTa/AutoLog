//
//  MapViewController.swift
//  AutoLog
//
//  Created by Milen Halachev on 23.05.18.
//  Copyright © 2018 KoCMoHaBTa. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var points: [MKAnnotation] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        MKDirections
//        MKDirectionsRequest
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.mapView.showAnnotations(self.points, animated: animated)
    }
    
    //MARK: - MKMapViewDelegate
}
