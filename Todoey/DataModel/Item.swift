//
//  Item.swift
//  Todoey
//
//  Created by Eyüp Mert on 28.12.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

#warning("3. step")
// Also subclasses realm object.
class Item : Object {

    // Has properties like similar.
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    // We added this property later than upper 2. So this gives an error in realm. Because our old objects doesn't has this property.
    @objc dynamic var dateCreated : Date?
    // Inverse relationship defining in realm.
    // This links each item back to a parentCategory and we specify fromType and property.
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
