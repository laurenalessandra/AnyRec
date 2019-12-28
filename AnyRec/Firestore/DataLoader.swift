//
//  DataLoader.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import Foundation

protocol DataLoader {
    
    func loadData(dataType: DataType, completed: @escaping() -> ())
    
}
