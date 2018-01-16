//
//  ItemDetails.swift
//  Todoey
//
//  Created by Hitender Thejaswi on 1/13/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import Foundation

class ItemData: Encodable, Decodable {
    
    var title  : String = ""
    var done : Bool = false
    
}
