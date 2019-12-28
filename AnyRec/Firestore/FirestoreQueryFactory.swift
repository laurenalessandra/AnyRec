//
//  FirestoreQueryFactory.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation
import Firebase

class FirestoreQueryFactory {
    
    var city: City?
    let db = Firestore.firestore()
    
    init() { }
    
    init(city: City) {
        self.city = city
    }
    
    func createLoadQuery() -> Query {
        guard let place = city else {
            return  db.collection("cities").whereField("postingUserID", isEqualTo: Auth.auth().currentUser?.uid)
        }
        return db.collection("cities").document(place.documentID).collection("venues")
    }
    
    func createDeleteQuery(documentID: String) -> DocumentReference {
        guard let place = city else {
            return db.collection("cities").document(documentID)
        }
        return db.collection("cities").document(place.documentID).collection("venues").document(documentID)
    }
    
    func createSaveQuery(documentID: String) -> DocumentReference {
        guard let place = city else {
            return db.collection("cities").document(documentID)
        }
        return db.collection("cities").document(place.documentID).collection("venues").document(documentID)
    }
    
    func createEmptySaveQuery() -> CollectionReference {
        guard let place = city else {
            return db.collection("cities")
        }
        return db.collection("cities").document(place.documentID).collection("venues")
    }
}
