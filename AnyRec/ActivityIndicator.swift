//
//  ActivityIndicator.swift
//  AnyRec
//
//  Created by Lauren Simon on 29.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import UIKit

class ActivityIndicator {
    
    static func createActivityIndicator(view: UIView) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        indicator.center = view.center
        view.addSubview(indicator)
        view.bringSubviewToFront(indicator)
        return indicator
    }
}
