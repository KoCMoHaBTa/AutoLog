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
    
    @IBAction func showRoute() {
        
        guard self.points.count > 1 else {
            
            return
        }
        
        let group = DispatchGroup()
        var routes: [MKRoute] = []
        var _source: MKMapItem? = nil
        for point in self.points {
            
            guard let source = _source else {
                
                _source = MKMapItem(placemark: MKPlacemark(coordinate: point.coordinate))
                continue
            }
            
            _source = MKMapItem(placemark: MKPlacemark(coordinate: point.coordinate))
            
            group.enter()
            
            let request = MKDirectionsRequest()
            request.source = source
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: point.coordinate))
            request.transportType = .automobile
            request.requestsAlternateRoutes = false
            
            let directions = MKDirections(request: request)
            directions.calculate { (response, error) in
                
                routes += response?.routes ?? []
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            
            self?.mapView.addOverlays(routes.map({ $0.polyline }))
            
            let totalMeters = routes.reduce(0.0, { $0 + $1.distance })
            let totalKm = totalMeters / 1000
            self?.title = "\(totalKm)km"
        }
    }
    
    //MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.fillColor = .red
        renderer.strokeColor = .green
        renderer.lineWidth = 2
        return renderer
    }
}
