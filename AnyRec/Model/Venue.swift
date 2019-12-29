//
//  Venue.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation

class Venue: FirestoreData {
    
    // is place ID same thing as documentiD?
    var placeID = ""
    var name: String
    var location: String
    var neighbourhood: String
    var category: String
    var iconURLPrefix: String
    var iconURLSuffix: String
    var review: String
    var reviewer: String
    var isFilled: Bool
    var documentID: String
    var postingUserID: String
    var cityDocumentID: String
    var longitude: Double
    var latitude: Double
    var intent: String
    var venueID: String

    var dictionary: [String: Any] {
        return ["name": name, "location": location, "neighbourhood": neighbourhood, "category": category, "iconURLPrefix": iconURLPrefix, "iconURLSuffix": iconURLSuffix, "review": review, "reviewer": reviewer, "isFilled": isFilled, "postingUserID": postingUserID, "cityDocumentID": cityDocumentID, "longitude": longitude, "latitude": latitude, "intent": intent, "venueID": venueID]
    }
    
    init(name: String, location: String, neighbourhood: String, category: String, iconURLPrefix: String, iconURLSuffix: String, review: String, reviewer: String, isFilled: Bool, documentID: String, postingUserID: String, cityDocumentID: String, longitude: Double, latitude: Double, intent: String, venueID: String) {
        self.name = name
        self.location = location
        self.neighbourhood = neighbourhood
        self.category = category
        self.iconURLPrefix = iconURLPrefix
        self.iconURLSuffix = iconURLSuffix
        self.review = review
        self.reviewer = reviewer
        self.isFilled = isFilled
        self.documentID = documentID
        self.postingUserID = postingUserID
        self.cityDocumentID = cityDocumentID
        self.longitude = longitude
        self.latitude = latitude
        self.intent = intent
        self.venueID = venueID
    }
    
    convenience init() {
        self.init(name: "", location: "", neighbourhood: "", category: "", iconURLPrefix: "", iconURLSuffix: "", review: "", reviewer: "", isFilled: false, documentID: "", postingUserID: "", cityDocumentID: "", longitude: 0.0, latitude: 0.0, intent: "", venueID: "")
    }
    
    required convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let location = dictionary["location"] as! String? ?? ""
        let neighbourhood = dictionary["neighbourhood"] as! String? ?? ""
        let category = dictionary["category"] as! String? ?? ""
        let iconURLPrefix = dictionary["iconURLPrefix"] as! String? ?? ""
        let iconURLSuffix = dictionary["iconURLSuffix"] as! String? ?? ""
        let review = dictionary["review"] as! String? ?? ""
        let reviewer = dictionary["reviewer"] as! String? ?? ""
        let isFilled = dictionary["isFilled"] as! Bool? ?? false
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let cityDocumentID = dictionary["cityDocumentID"] as! String? ?? ""
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let intent = dictionary["intent"] as! String? ?? ""
        let venueID = dictionary["venueID"] as! String? ?? ""
        self.init(name: name, location: location, neighbourhood: neighbourhood, category: category, iconURLPrefix: iconURLPrefix, iconURLSuffix: iconURLSuffix, review: review, reviewer: reviewer, isFilled: isFilled, documentID: "", postingUserID: postingUserID, cityDocumentID: cityDocumentID, longitude: longitude, latitude: latitude, intent: intent, venueID: venueID)
    }
   
}

