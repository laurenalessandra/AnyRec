//
//  AlertGenerator.swift
//  AnyRec
//
//  Created by Lauren Simon on 29.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import UIKit

class AlertGenerator {
    
    static func displayAlert(title: String, message: String, button: String, nav: UINavigationController?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: { alert in
            if let navigation = nav {
                navigation.popViewController(animated: true)
            } else {
                nav?.dismiss(animated: true, completion: nil)
            }
        }))
        nav?.present(alert, animated: true, completion: nil)
    }
}
