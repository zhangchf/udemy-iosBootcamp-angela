//
//  CDHelper.swift
//  Todos
//
//  Created by Chaofan Zhang on 29/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import Foundation
import CoreData

let gPersistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "TodoDataModel")
    container.loadPersistentStores { (persistentStoreDescription, error) in
        if let error = error {
            fatalError("Couldn't load data store, \(error)")
        }
    }
    return container
}()

let gPersistentContainerContext = gPersistentContainer.viewContext

