//
//  Message.swift
//  FlashChat
//
//  Created by Chaofan Zhang on 27/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import Foundation

class Message {
    var sender: String = ""
    var message: String = ""
    
    init(sender: String, message: String) {
        self.sender = sender
        self.message = message
    }
}
