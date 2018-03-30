//
//  RealmItem.swift
//  Todos
//
//  Created by Chaofan Zhang on 30/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import Foundation
import RealmSwift

class RealmItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate: Date = Date()
    let category = LinkingObjects(fromType: RealmCategory.self, property: "todoItems")
}
