//
//  TodoItem.swift
//  Todos
//
//  Created by Chaofan Zhang on 28/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import Foundation

class TodoItem: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
    
    init(title: String, done: Bool = false) {
        self.title = title
    }
}
