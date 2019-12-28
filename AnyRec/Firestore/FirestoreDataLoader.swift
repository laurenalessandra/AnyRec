//
//  FirestoreDataLoader.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation
import Firebase

class FirestoreDataLoader: DataLoader {
    
    var firestoreData = [FirestoreData]()
    var loadQuery: Query
    var db = Firestore.firestore()
    
    init(city: City) {
        let queryFactory = FirestoreQueryFactory(city: city)
        loadQuery = queryFactory.createLoadQuery()
    }
    
    init() {
        let queryFactory = FirestoreQueryFactory()
        loadQuery = queryFactory.createLoadQuery()
    }
    
    func loadData(dataType: DataType, completed: @escaping () -> ()) {
        loadQuery.addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                return completed()
            }
            self.firestoreData = []
            for document in querySnapshot!.documents {
                var data = FirestoreDataFactory.createData(dataType: dataType, dictionary: document.data())
                data.documentID = document.documentID
                self.firestoreData.append(data)
            }
            completed()
        }
    }
    
}

