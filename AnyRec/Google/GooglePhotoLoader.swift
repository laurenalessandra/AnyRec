//
//  GooglePhotoLoader.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation
import GooglePlaces

class GooglePhotoLoader {
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    func loadImageFromMetadata(placeID: String, photoMetadata: GMSPlacePhotoMetadata, imageView: UIImageView) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: { photo, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if photo == nil {
                    imageView.image = UIImage(named: "empty-card")
                    imageView.contentMode = .scaleAspectFill
                } else {
                    self.imageCache.setObject(photo!, forKey: placeID as AnyObject)
                    imageView.image = photo
                    imageView.contentMode = .scaleAspectFill
                }
            }
        })
    }
    
    func loadFirstPhotoForPlace(placeID: String, imageView: UIImageView) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { photos, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageFromMetadata(placeID: placeID, photoMetadata: firstPhoto, imageView: imageView)
                } else {
                    imageView.image = UIImage(named: "empty-card")
                    imageView.contentMode = .scaleAspectFill
                }
            }
            
        }
    }
}
