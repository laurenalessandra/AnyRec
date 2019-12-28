//
//  GreetingSimulator.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation

class GreetingSimulator {
    
    static func determineGreeting() -> String {
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if hour >= 0 && hour < 12 {
            return "Good morning!"
        } else if hour >= 12 && hour < 19 {
            return "Good afternoon!"
        } else {
            return "Good evening!"
        }
    }
    
}
