//
//  City.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase

class City: FirestoreData {

    var placeID: String
    var venueArray: [Venue] = []
    var searchArray: [Venue] = []
    var itineraryArray: [Venue] = []
    var postingUserID: String
    var documentID: String
    var name: String
    var latitude = 0.0
    var longitude = 0.0
    let client_id = "VMCYU5Z51AKJFTCDFMQIVR4UEA2WQN13H1OFE2AOQWIJG0S0"
    let client_secret = "RW00IVPBAFAH4IBTKYLBM1VJWPNOIHDLHBI34X04JMMKOF40"
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
    
    func getCityDetails(offset: Int, intent: String, completed: @escaping () -> ()) {
        let url = "https://api.foursquare.com/v2/search/recommendations?ll=\(latitude),\(longitude)&v=20160607&intent=\(intent)&limit=20&offset=\(offset)&client_id=\(client_id)&client_secret=\(client_secret)"
        venueArray = []
        AF.request(url).responseJSON { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let numberOfPoints = json["response"]["group"]["results"].count
                if numberOfPoints > 1 {
                    for index in 0...numberOfPoints - 1 {
                        let name = json["response"]["group"]["results"][index]["venue"]["name"].stringValue
                        let location = json["response"]["group"]["results"][index]["venue"]["location"]["address"].stringValue
                        let neighbourhood = json["response"]["group"]["results"][index]["venue"]["location"]["neighborhood"].stringValue
                        let category = json["response"]["group"]["results"][index]["venue"]["categories"][0]["name"].stringValue
                        let iconURLPrefix = json["response"]["group"]["results"][index]["photo"]["prefix"].stringValue
                        let iconURLSuffix = json["response"]["group"]["results"][index]["photo"]["suffix"].stringValue
                        let review = json["response"]["group"]["results"][index]["snippets"]["items"][0]["detail"]["object"]["text"].stringValue
                        let reviewer = json["response"]["group"]["results"][index]["snippets"]["items"][0]["detail"]["object"]["user"]["firstName"].stringValue
                        let longitude = json["response"]["group"]["results"][index]["venue"]["location"]["lng"].doubleValue
                        let latitude = json["response"]["group"]["results"][index]["venue"]["location"]["lat"].doubleValue
                        let venueID = json["response"]["group"]["results"][index]["venue"]["id"].stringValue
                        self.venueArray.append(Venue(name: name, location: location, neighbourhood: neighbourhood, category: category, iconURLPrefix: iconURLPrefix, iconURLSuffix: iconURLSuffix, review: review, reviewer: reviewer, isFilled: false, documentID: "", postingUserID: "", cityDocumentID: "", longitude: longitude, latitude: latitude, intent: intent, venueID: venueID))
                }
                }
            case .failure( _):
                print("***** ERROR: failed to get data from url")
            }
            completed()
        }
    }

    func getCitySearch(query: String, completed: @escaping () -> ()) {
        let url = "https://api.foursquare.com/v2/venues/search?ll=\(latitude),\(longitude)&query=\(query)&limit=50&client_id=VMCYU5Z51AKJFTCDFMQIVR4UEA2WQN13H1OFE2AOQWIJG0S0&client_secret=RW00IVPBAFAH4IBTKYLBM1VJWPNOIHDLHBI34X04JMMKOF40&v=20181109"
        print("Print URL")
        print(url)
        searchArray = []
        AF.request(url).responseJSON { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let numberOfPoints = json["response"]["venues"].count
                print(numberOfPoints)
                if numberOfPoints > 1 {
                    for index in 0...numberOfPoints - 1 {
                        let name = json["response"]["venues"][index]["name"].stringValue
                        let location = json["response"]["venues"][index]["location"]["address"].stringValue
                        let neighbourhood = json["response"]["venues"][index]["location"]["neighborhood"].stringValue
                        let category = json["response"]["venues"][index]["categories"][0]["name"].stringValue
                        let iconURLPrefix = json["response"]["venues"][index]["categories"][0]["icon"]["prefix"].stringValue
                        let iconURLSuffix = json["response"]["venues"][index]["categories"][0]["icon"]["suffix"].stringValue
                        let longitude = json["response"]["venues"][index]["location"]["lng"].doubleValue
                        let latitude = json["response"]["venues"][index]["location"]["lat"].doubleValue
                        let venueID = json["response"]["venues"][index]["id"].stringValue
                        
                        self.searchArray.append(Venue(name: name, location: location, neighbourhood: neighbourhood, category: category, iconURLPrefix: iconURLPrefix, iconURLSuffix: iconURLSuffix, review: "", reviewer: "", isFilled: false, documentID: "", postingUserID: "", cityDocumentID: "", longitude: longitude, latitude: latitude, intent: "", venueID: venueID))
                    }
                }
            case .failure( _):
                print("***** ERROR: failed to get data from url")
            }
            completed()
        }
    }
}
