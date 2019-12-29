//
//  SightDetailViewController.swift
//  AnyRec
//
//  Created by Lauren Simon on 29.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class SightDetailViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var neighbourhood: UILabel!
    @IBOutlet weak var review: UITextView!
    @IBOutlet weak var reviewer: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var reviewerIcon: UIImageView!
    
    var venue: Venue!
    var city: City!
    let regionDistance: CLLocationDistance = 750
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabels()
        setUpMapView()
    }
    
    func setUpMapView() {
        let coordinates = CLLocationCoordinate2D(latitude: venue.latitude, longitude: venue.longitude)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = venue.name
        mapView.addAnnotation(annotation)
        mapView.setCenter(coordinates, animated: true)
        mapView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func viewDidLayoutSubviews() {
        review.setContentOffset(.zero, animated: false)
    }
    
    func setUpLabels() {
        name.text = venue.name
        category.text = venue.category
        neighbourhood.text = venue.neighbourhood
        address.text = venue.location
        review.text = venue.review
        reviewer.text = venue.reviewer
        
        if venue.review == "" && venue.reviewer == "" {
            reviewerIcon.isHidden = true
        }
    }
    
    @IBAction func directionsPressed(_ sender: UIButton) {
        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(venue.latitude, venue.longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = venue.name
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func openFoursquarePressed(_ sender: UIButton) {
        let venueURL = "http://foursquare.com/v/" + venue.venueID
        let safariVC = SFSafariViewController(url: NSURL(string: venueURL)! as URL)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToItineraryPressed(_ sender: UIBarButtonItem) {
        let dataUpdater = FirestoreDataUpdater(city: city, documentID: venue.documentID)
        dataUpdater.saveData(data: venue) { success in
            if success {
                AlertGenerator.displayAlert(title: "Added!", message: "Sight added to your itinerary.", button: "Okay", nav: self.navigationController)
            }
        }
    }
    
}
