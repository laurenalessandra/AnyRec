//
//  SearchViewController.swift
//  AnyRec
//
//  Created by Lauren Simon on 29.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var city: City!
    var index = 0
    var offset = 0
    var query: String!
    var searchLoader = FoursquareLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let indicator = ActivityIndicator.createActivityIndicator(view: view)
        indicator.startAnimating()
        let search = searchBar.text ?? ""
        let query = search.replacingOccurrences(of: " ", with: "%20")
        
        searchLoader.getCitySearchResults(city: city, query: query) {
            indicator.stopAnimating()
            self.collectionView.reloadData()
            
            if self.searchLoader.venues.isEmpty {
                AlertGenerator.displayAlert(title: "No sights!", message: "", button: "Okay", nav: self.navigationController)
            }
        }
    }

}
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchLoader.venues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let venue = searchLoader.venues[indexPath.row] as Venue
        let url = "\(venue.iconURLPrefix)88\(venue.iconURLSuffix)"
        
        let photoURL = NSURL(string: url)
        if let photoData = NSData(contentsOf: photoURL! as URL) {
            searchCell.searchImage.image = UIImage(data: photoData as Data)
        }
        
        searchCell.searchName.text = venue.name
        searchCell.searchAddress.text = venue.location
        searchCell.searchCategory.text = venue.category
        searchCell.layer.cornerRadius = 7
        return searchCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        index = indexPath.row
        return true
    }
}
