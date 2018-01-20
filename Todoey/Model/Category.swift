//
//  Category.swift
//  Todoey
//
//  Created by Hitender Thejaswi on 1/19/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    
    //One-To-Many Relationship
    let items = List<Item>()
}
