//
//  RealmHelper.swift
//  Todos
//
//  Created by Chaofan Zhang on 2018/4/2.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import Foundation
import RealmSwift

let realmConfig = Realm.Configuration(schemaVersion: 5, migrationBlock: {
    (migration, oldSchemaVersion) in
    if oldSchemaVersion < 4 {
        migration.enumerateObjects(ofType: RealmCategory.className()) { oldObject, newObject in
            // combine name fields into a single field
            newObject!["cellColor"] = UIColor.white.hexValue()
        }
        migration.enumerateObjects(ofType: RealmItem.className()) { oldObject, newObject in
            // combine name fields into a single field
            newObject!["cellColor"] = UIColor.white.hexValue()
        }
    }
    if oldSchemaVersion == 4 {
        // delete RealmItem.cellColor column.
    }
})

let gRealm = try! Realm(configuration: realmConfig)

