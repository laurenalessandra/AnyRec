//
//  FoursquareRecLoader.swift
//  AnyRec
//
//  Created by Lauren Simon on 29.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FoursquareRecLoader {
    
    var venues = [Venue]()
    var url = FoursquareURLGenerator()
    
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
                        let iconURLPrefix = photo["prefix"].stringValue
                        let iconURLSuffix = photo["suffix"].stringValue
                        let reviewText = review["text"].stringValue
                        let reviewer = review["user"]["firstName"].stringValue
                        let longitude = details["location"]["lng"].doubleValue
                        let latitude = details["location"]["lat"].doubleValue
                        let venueID = details["id"].stringValue
                        self.venues.append(Venue(name: name, location: location, neighbourhood: neighbourhood, category: category, iconURLPrefix: iconURLPrefix, iconURLSuffix: iconURLSuffix, review: reviewText, reviewer: reviewer, isFilled: false, documentID: "", postingUserID: "", cityDocumentID: "", longitude: longitude, latitude: latitude, intent: intent, venueID: venueID))
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            completed()
        }
    }
    
}
