//
//  ItineraryMapViewController.swift
//  AnyRec
//
//  Created by Lauren Simon on 29.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import UIKit
import MapKit

class ItineraryMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var dataLoader: FirestoreDataLoader!
    var city: City!
    var allVenues = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataLoader = FirestoreDataLoader(city: city)
        dataLoader.loadData(dataType: .venues) {
            var annotations = [MKPointAnnotation]()
            var latitudes = [Double]()
            var longitudes = [Double]()
            for venue in self.dataLoader.firestoreData {
                let annotation = MKPointAnnotation()
                let coordinates = CLLocationCoordinate2D(latitude: venue.latitude, longitude: venue.longitude)
                latitudes.append(venue.latitude)
                longitudes.append(venue.longitude)
                annotation.coordinate = coordinates
                annotation.title = venue.name
                annotations.append(annotation)
            }
            self.mapView.showAnnotations(annotations, animated: true)
        }
    }
    
}
