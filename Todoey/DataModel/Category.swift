//
//  Category.swift
//  Todoey
//
//  Created by Eyüp Mert on 28.12.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

#warning("2. step")
// Subclass and create realm object.
class Category : Object {
    // Specify properties for class. With @objc dynamic key, we keep it updated dynamically.
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    // Create relationship with item. Each category can have number of items.
    // And that's a list of item object.
    // List of item object array. Just different syntax.
    let items = List<Item>()
    
}
