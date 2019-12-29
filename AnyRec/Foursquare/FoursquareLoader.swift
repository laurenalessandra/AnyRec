//
//  FoursquareLoader.swift
//  AnyRec
//
//  Created by Lauren Simon on 29.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FoursquareLoader {
    
    var venues = [Venue]()
    var url = FoursquareURLGenerator()
    
    func getCitySearchResults(city: City, query: String, completed: @escaping () -> ()) {
        venues = []
        AF.request(url.getSearchURL(latitude: city.latitude, longitude: city.longitude, query: query)).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let amount = json["response"]["venues"].count
                if amount > 1 {
                    for index in 0...amount - 1 {
                        let details = json["response"]["venues"][index]
                        let name = details["name"].stringValue
                        let location = details["location"]["address"].stringValue
                        let neighbourhood = details["location"]["neighborhood"].stringValue
                        let category = details["categories"][0]["name"].stringValue
                        let prefix = details["categories"][0]["icon"]["prefix"].stringValue
                        let suffix = details["categories"][0]["icon"]["suffix"].stringValue
                        let longitude = details["location"]["lng"].doubleValue
                        let latitude = details["location"]["lat"].doubleValue
                        let venueID = details["id"].stringValue
                        
                        self.venues.append(Venue(name: name, location: location, neighbourhood: neighbourhood, category: category, iconURLPrefix: prefix, iconURLSuffix: suffix, review: "", reviewer: "", isFilled: false, documentID: "", postingUserID: "", cityDocumentID: "", longitude: longitude, latitude: latitude, intent: "", venueID: venueID))
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            completed()
        }
    }
    
    func getCityRecommendations(city: City, offset: Int, intent: String, completed: @escaping () -> ()) {
        venues = []
        AF.request(url.getRecommendationsURL(latitude: city.latitude, longitude: city.longitude, intent: intent, offset: offset)).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let amount = json["response"]["group"]["results"].count
                if amount > 1 {
                    for index in 0...amount - 1 {
                        let details = json["response"]["group"]["results"][index]["venue"]
                        let photo = json["response"]["group"]["results"][index]["photo"]
                        let review = json["response"]["group"]["results"][index]["snippets"]["items"][0]["detail"]["object"]
                        let name = details["name"].stringValue
                        let location = details["location"]["address"].stringValue
                        let neighbourhood = details["location"]["neighborhood"].stringValue
                        let category = details["categories"][0]["name"].stringValue
                        let prefix = photo["prefix"].stringValue
                        let suffix = photo["suffix"].stringValue
                        let reviewText = review["text"].stringValue
                        let reviewer = review["user"]["firstName"].stringValue
                        let longitude = details["location"]["lng"].doubleValue
                        let latitude = details["location"]["lat"].doubleValue
                        let venueID = details["id"].stringValue
                        self.venues.append(Venue(name: name, location: location, neighbourhood: neighbourhood, category: category, iconURLPrefix: prefix, iconURLSuffix: suffix, review: reviewText, reviewer: reviewer, isFilled: false, documentID: "", postingUserID: "", cityDocumentID: "", longitude: longitude, latitude: latitude, intent: intent, venueID: venueID))
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            completed()
        }
    }
    
}
