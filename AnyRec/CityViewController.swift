//
//  CityViewController.swift
//  AnyRec
//
//  Created by Lauren Simon on 29.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
    @IBOutlet weak var recCollectionView: UICollectionView!
    @IBOutlet weak var othersCollectionView: UICollectionView!
    var city: City!
    var recIndex: Int!
    
    let others = ["Itinerary", "Itinerary Map", "Search"]
    let othersSegues = ["ShowItinerary", "ShowMap", "ShowSearch"]
    let recommendations = ["Food", "Drinks", "Desserts", "Fun", "Shopping", "Sights"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recCollectionView.dataSource = self
        recCollectionView.delegate = self
        othersCollectionView.dataSource = self
        othersCollectionView.delegate = self
        
        recCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        othersCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowSights":
            let destination = segue.destination as! SightsViewController
            destination.city = city
            destination.intent = recIndex
        case "ShowItinerary":
            let destination = segue.destination as! ItineraryViewController
            destination.city = city
        case "ShowMap":
            let destination = segue.destination as! ItineraryMapViewController
            destination.city = city
        case "ShowSearch":
            let destination = segue.destination as! SearchViewController
            destination.city = city
        default:
            return
        }
    }

}
extension CityViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == recCollectionView ? recommendations.count : others.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recCollectionView {
            let recommendationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationCell", for: indexPath) as! RecommendationCell
            recommendationCell.recName.setTitle("   \(recommendations[indexPath.row])", for: .normal)
            recommendationCell.recName.contentHorizontalAlignment = .left
            recommendationCell.recImage.image = UIImage(named: recommendations[indexPath.row])
            return recommendationCell
        } else {
            let otherCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherCell", for: indexPath) as! OtherCell
            otherCell.otherName.setTitle("  \(others[indexPath.row])", for: .normal)
            otherCell.otherName.contentHorizontalAlignment = .left
            otherCell.otherImage.image = UIImage(named: others[indexPath.row])
            return otherCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recCollectionView {
            recIndex = indexPath.row
        } else {
            performSegue(withIdentifier: othersSegues[indexPath.row], sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView == recCollectionView {
            recIndex = indexPath.row
        }
        return true
    }

}
