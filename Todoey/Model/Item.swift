//
//  Item.swift
//  Todoey
//
//  Created by Hitender Thejaswi on 1/19/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    
    //Inverse Relationship
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
