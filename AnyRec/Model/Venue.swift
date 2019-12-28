//
//  Venue.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation
import Firebase
import Alamofire
import SwiftyJSON


class Venue: FirestoreData {
    
    // is place ID same thing as documentiD?
    var placeID = ""
    var name = ""
    var location = ""
    var neighbourhood = ""
    var category = ""
    var iconURLPrefix = ""
    var iconURLSuffix = ""
    var review = ""
    var reviewer = ""
    var isFilled = false
    var documentID = ""
    var postingUserID = ""
    var cityDocumentID = ""
    var longitude = 0.0
    var latitude = 0.0
    var intent = ""
    var venueID = ""

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
        let documentID = dictionary["documentID"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let cityDocumentID = dictionary["cityDocumentID"] as! String? ?? ""
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let intent = dictionary["intent"] as! String? ?? ""
        let venueID = dictionary["venueID"] as! String? ?? ""
        self.init(name: name, location: location, neighbourhood: neighbourhood, category: category, iconURLPrefix: iconURLPrefix, iconURLSuffix: iconURLSuffix, review: review, reviewer: reviewer, isFilled: isFilled, documentID: "", postingUserID: postingUserID, cityDocumentID: cityDocumentID, longitude: longitude, latitude: latitude, intent: intent, venueID: venueID)
    }
    
    func getVenueReview(completed: @escaping () -> ()) {
        let tipURL = "https://api.foursquare.com/v2/venues/\(venueID)/tips?client_id=VMCYU5Z51AKJFTCDFMQIVR4UEA2WQN13H1OFE2AOQWIJG0S0&client_secret=RW00IVPBAFAH4IBTKYLBM1VJWPNOIHDLHBI34X04JMMKOF40&v=20181109"
        AF.request(tipURL).responseJSON { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let review = json["response"]["tips"]["items"][0]["text"].stringValue
                let firstName = json["response"]["tips"]["items"][0]["user"]["firstName"].stringValue
                let lastName = json["response"]["tips"]["items"][0]["user"]["lastName"].stringValue
                let reviewer = "\(firstName) \(lastName)"
                self.review = review
                self.reviewer = reviewer
            case .failure( _):
                print("***** ERROR: failed to get data from url")
            }
            completed()
        }
    }
    
    func getVenuePhoto(completed: @escaping () -> ()) {
        let photoURL = "https://api.foursquare.com/v2/venues/\(venueID)?client_id=VMCYU5Z51AKJFTCDFMQIVR4UEA2WQN13H1OFE2AOQWIJG0S0&client_secret=RW00IVPBAFAH4IBTKYLBM1VJWPNOIHDLHBI34X04JMMKOF40&v=20181109"
        AF.request(photoURL).responseJSON { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let iconURLPrefix = json["response"]["venue"]["bestPhoto"]["prefix"].stringValue
                let iconURLSuffix = json["response"]["venue"]["bestPhoto"]["suffix"].stringValue
                self.iconURLPrefix = iconURLPrefix
                self.iconURLSuffix = iconURLSuffix
            case .failure( _):
                print("***** ERROR: failed to get data from url")
            }
        }
    }
}

