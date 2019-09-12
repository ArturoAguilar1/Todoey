//
//  Items.swift
//  Todoey
//
//  Created by Arturo  Aguilar Lopez on 09/09/2019.
//  Copyright © 2019 Arturo  Aguilar Lopez. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var itemColour : String = ""
    
    //Inverse relationships
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
