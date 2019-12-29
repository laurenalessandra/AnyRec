//
//  City.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation

class City: FirestoreData {

    var placeID: String
    var postingUserID: String
    var documentID: String
    var name: String
    var latitude = 0.0
    var longitude = 0.0
    var intent = ""
    
    var dictionary: [String: Any] {
        return ["name": name, "latitude": latitude, "longitude": longitude, "placeID": placeID, "postingUserID": postingUserID]
    }
    
    init(name: String, latitude: Double, longitude: Double, placeID: String, postingUserID: String, documentID: String) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.placeID = placeID
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(name: "", latitude: 0.0, longitude: 0.0, placeID: "", postingUserID: "", documentID: "" )
    }
    
    required convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let placeID = dictionary["placeID"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(name: name, latitude: latitude, longitude: longitude, placeID: placeID, postingUserID: postingUserID, documentID: "")
        
    }

}
