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
    
    let others = ["Itinerary", "Itinerary Map", "Search"]
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
            recommendationCell.layer.cornerRadius = 10
            recommendationCell.recImage.image = UIImage(named: recommendations[indexPath.row])
            return recommendationCell
        } else {
            let otherCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherCell", for: indexPath) as! OtherCell
            otherCell.otherName.setTitle("  \(others[indexPath.row])", for: .normal)
            otherCell.otherName.contentHorizontalAlignment = .left
            otherCell.layer.cornerRadius = 7
            otherCell.layer.masksToBounds = true
            otherCell.otherImage.image = UIImage(named: others[indexPath.row])
            return otherCell
        }
    }

}
