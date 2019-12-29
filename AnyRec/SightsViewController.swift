//
//  SightsViewController.swift
//  AnyRec
//
//  Created by Lauren Simon on 29.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import UIKit

class SightsViewController: UIViewController {

    var imageCache = NSCache<NSString, UIImage>()
    @IBOutlet weak var collectionView: UICollectionView!
    var recLoader = FoursquareRecLoader()
    var intent: Int!
    var city: City!
    var offset = 0
    var index: Int!
    var intentArray = ["food", "drinks", "dessert", "fun", "shopping", "sights"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let indicator = ActivityIndicator.createActivityIndicator(view: view)
        indicator.startAnimating()
        
        recLoader.getCityRecommendations(city: city, offset: offset, intent: intentArray[intent]) {
            indicator.stopAnimating()
            self.collectionView.reloadData()
            
            if self.recLoader.venues.isEmpty {
                AlertGenerator.displayAlert(title: "No sights!", message: "", button: "Okay", nav: self.navigationController)
            }
        }
    }
    
    @IBAction func previousPressed(_ sender: UIBarButtonItem) {
        if offset >= 20 {
            offset -= 20
        }
        let indicator = ActivityIndicator.createActivityIndicator(view: view)
        indicator.startAnimating()
        recLoader.getCityRecommendations(city: city, offset: offset, intent: intentArray[intent]) {
            indicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func nextPressed(_ sender: UIBarButtonItem) {
        offset += 20
        let indicator = ActivityIndicator.createActivityIndicator(view: view)
        indicator.startAnimating()
        
        recLoader.getCityRecommendations(city: city, offset: offset, intent: intentArray[intent]) {
            indicator.stopAnimating()
            self.collectionView.reloadData()
            
            if self.recLoader.venues.isEmpty {
                AlertGenerator.displayAlert(title: "No more sights!", message: "Will display the previous 20 sights", button: "Okay", nav: self.navigationController)
                
                self.offset -= 20
                indicator.startAnimating()
                self.recLoader.getCityRecommendations(city: self.city, offset: self.offset, intent: self.intentArray[self.intent]) {
                    indicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSightDetail" {
            let destination = segue.destination as! SightDetailViewController
            destination.venue = recLoader.venues[index]
            destination.city = city
        }
    }

}
extension SightsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recLoader.venues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sightCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SightCell", for: indexPath) as! SightCell
        
        let url = FoursquareURLGenerator.getPhotoURL(prefix: recLoader.venues[indexPath.row].iconURLPrefix, suffix: recLoader.venues[indexPath.row].iconURLSuffix)
        
        sightCell.sightImage.image = UIImage(named: "empty-card")
        if let photoURL = URL(string: url) {
            sightCell.sightImage.downloadImageToCache(url: photoURL, imageCache: imageCache)
        }
        
        sightCell.sightImage.layer.masksToBounds = true
        sightCell.sightName.text = recLoader.venues[indexPath.row].name
        sightCell.sightAddress.text = recLoader.venues[indexPath.row].location
        sightCell.sightCategory.text = recLoader.venues[indexPath.row].category
        sightCell.layer.cornerRadius = 7
        return sightCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        index = indexPath.row
        return true
    }
}
