//
//  FoursquareURLQuery.swift
//  AnyRec
//
//  Created by Lauren Simon on 29.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation

class FoursquareURLGenerator {
    
    let client_id = "VMCYU5Z51AKJFTCDFMQIVR4UEA2WQN13H1OFE2AOQWIJG0S0"
    let client_secret = "RW00IVPBAFAH4IBTKYLBM1VJWPNOIHDLHBI34X04JMMKOF40"
    
    func getRecommendationsURL(latitude: Double, longitude: Double, intent: String, offset: Int) -> String {
        return "https://api.foursquare.com/v2/search/recommendations?ll=\(latitude),\(longitude)&v=20160607&intent=\(intent)&limit=20&offset=\(offset)&client_id=\(client_id)&client_secret=\(client_secret)"
    }
    
    func getSearchURL(latitude: Double, longitude: Double, query: String) -> String {
        return "https://api.foursquare.com/v2/venues/search?ll=\(latitude),\(longitude)&query=\(query)&limit=50&client_id=\(client_id)&client_secret=\(client_secret)"
    }
    
    static func getPhotoURL(prefix: String, suffix: String) -> String {
        return "\(prefix)300x500\(suffix)"
    }
    
}
