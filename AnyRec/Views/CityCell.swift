//
//  CityCell.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import UIKit

class CityCell: UICollectionViewCell {
    
    @IBOutlet weak var cityName: UIButton!
    @IBOutlet weak var cityImage: UIImageView!
    
    func updateName(_ city: City) {
        cityName.setTitle("  \(city.name)", for: .normal)
        cityName.titleLabel?.adjustsFontSizeToFitWidth = true
        cityName.contentHorizontalAlignment = .left
    }
}
