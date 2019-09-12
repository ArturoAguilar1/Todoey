//
//  Category.swift
//  Todoey
//
//  Created by Arturo  Aguilar Lopez on 09/09/2019.
//  Copyright © 2019 Arturo  Aguilar Lopez. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    let items = List<Item>()
}
