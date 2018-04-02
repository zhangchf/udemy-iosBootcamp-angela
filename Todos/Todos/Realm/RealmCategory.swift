//
//  RealmCategory.swift
//  Todos
//
//  Created by Chaofan Zhang on 30/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCategory: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = UIColor.white.hexValue()
    let todoItems = List<RealmItem>()
}
