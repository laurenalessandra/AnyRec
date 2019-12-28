//
//  FirestoreData.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation
import Firebase

protocol FirestoreData {
    
    init(dictionary: Dictionary<String,Any>)
    var documentID: String { get set }
    var name: String { get set }
    var placeID: String { get set }
    var latitude: Double { get set }
    var longitude: Double { get set }
    var dictionary: Dictionary<String, Any> { get }
    var postingUserID: String { get set }
    
}
