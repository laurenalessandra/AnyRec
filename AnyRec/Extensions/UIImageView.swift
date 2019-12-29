//
//  UIImageView.swift
//  AnyRec
//
//  Created by Lauren Simon on 29.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadImageToCache(url: URL, imageCache: NSCache<NSString, UIImage>) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
        } else {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    guard let imageToCache = UIImage(data: data) else { return }
                    imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
                    self.image = imageToCache
                }
                } .resume()
        }
    }
}
