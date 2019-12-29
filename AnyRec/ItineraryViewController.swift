//
//  ItineraryViewController.swift
//  AnyRec
//
//  Created by Lauren Simon on 29.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import UIKit

class ItineraryViewController: UIViewController {
    
    var city: City!
    var dataLoader: FirestoreDataLoader!
    var index = 0
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataLoader = FirestoreDataLoader(city: city)
        dataLoader.loadData(dataType: .venues) {
            self.collectionView.reloadData()
        }
    }

}
extension ItineraryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataLoader.firestoreData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itineraryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItineraryCell", for: indexPath) as! ItineraryCell
        let venue = dataLoader.firestoreData[indexPath.row] as! Venue
        var url: String
        if venue.iconURLSuffix == ".png" {
            url = "\(venue.iconURLPrefix)88\(venue.iconURLSuffix)"
        } else {
            url = "\(venue.iconURLPrefix)300x500\(venue.iconURLSuffix)"
        }
        
        itineraryCell.itineraryImage.image = UIImage(named: "empty-card")
        let photoURL = NSURL(string: url)
        if let photoData = NSData(contentsOf: photoURL! as URL) {
            itineraryCell.itineraryImage.image = UIImage(data: photoData as Data)
        }
        
        itineraryCell.itineraryName.text = venue.name
        itineraryCell.itineraryAddress.text = venue.location
        itineraryCell.itineraryCategory.text = venue.category
        
        itineraryCell.layer.cornerRadius = 7
        itineraryCell.layer.masksToBounds = true
        return itineraryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        index = indexPath.row
        return true
    }
}
