//
//  FirestoreDataFactory.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation
import Firebase

class FirestoreDataFactory {
    
    static func createData(dataType: DataType, dictionary: Dictionary<String, Any>) -> FirestoreData {
        switch dataType {
        case .cities: return City(dictionary: dictionary)
        case .venues: return Venue(dictionary: dictionary)
        }
    }
}
