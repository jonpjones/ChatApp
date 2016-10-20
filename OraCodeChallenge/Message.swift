//
//  Message.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/20/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import Foundation

struct Message {
    var chatID: Int
    var createdDate: Date
    var id: Int
    var message: String
    var userID: Int
    var userName: String

    init(newChatID: Int, created: Date, messageId: Int, newMessage: String, creatorID: Int, creatorName: String) {
        chatID = newChatID
        createdDate = created
        id = messageId
        message = newMessage
        userID = creatorID
        userName = creatorName
    }
}
