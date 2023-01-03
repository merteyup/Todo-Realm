//
//  Data.swift
//  Todoey
//
//  Created by Eyüp Mert on 28.12.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift


class Data: Object {
    
    // Dynamic is a decleration modifier. Tells the runtime use dynamic dispatch. Not static.
    // If user changes name, dynamically realm updates changes.
    // Realm can monitor changes while app is running.
    
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
    
}
