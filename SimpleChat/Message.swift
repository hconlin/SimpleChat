//
//  message.swift
//  DumbChat
//
//  Created by Hayden Conlin-Mouat on 2020-03-03.
//  Copyright © 2020 Hayden Conlin-Mouat. All rights reserved.
//

import Foundation

class Message {
    
    //MARK: Properties
    
    var messageText: String
    var username: String
    
    init?(username: String, messageText: String) {
        self.username = username
        self.messageText = messageText
    }
    
}
