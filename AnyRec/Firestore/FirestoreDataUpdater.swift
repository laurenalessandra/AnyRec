//
//  FirestoreDataUpdater.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation
import Firebase

class FirestoreDataUpdater {
    
    var db = Firestore.firestore()
    var deleteQuery: DocumentReference?
    var saveQuery: DocumentReference?
    var emptySaveQuery: CollectionReference?
    
    init(city: City, documentID: String) {
        let queryFactory = FirestoreQueryFactory(city: city)
        if documentID != "" {
            deleteQuery = queryFactory.createDeleteQuery(documentID: documentID)
            saveQuery = queryFactory.createSaveQuery(documentID: documentID)
        } else {
            emptySaveQuery = queryFactory.createEmptySaveQuery()
        }
    }
    
    init(documentID: String) {
        let queryFactory = FirestoreQueryFactory()
        if documentID != "" {
            deleteQuery = queryFactory.createDeleteQuery(documentID: documentID)
            saveQuery = queryFactory.createSaveQuery(documentID: documentID)
        } else {
            emptySaveQuery = queryFactory.createEmptySaveQuery()
        }
    }
    
    func deleteData(completion: @escaping (Bool) -> ()) {
        deleteQuery!.delete() { error in
            error != nil ? completion(false) : completion(true)
        }
    }
    
    func saveData(data: FirestoreData, completion: @escaping (Bool) -> ()) {
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            return completion(false)
        }
        
        var dataToSave = data.dictionary
        dataToSave["postingUserID"] = postingUserID
        
        if data.documentID != "" {
            saveQuery!.setData(dataToSave) { error in
                error != nil ? completion(false) : completion(true)
            }
        } else {
            // let firestore create the new documentID
            var ref: DocumentReference? = nil
            
            ref = emptySaveQuery!.addDocument(data: dataToSave) { error in
                error != nil ? completion(false) : completion(true)
                
            }
        }
    }
}
