//
//  Chat.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/20/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import Foundation

struct Chat {
    var created: Date
    var id: Int
    var name: String
    var lastMessage: Message
    var creatorName: String
    var creatorID: Int
    
    init(createdDate: Date, chatID: Int, chatName: String, message: Message, authorName: String, authorID: Int) {
        created = createdDate
        id = chatID
        name = chatName
        lastMessage = message
        creatorName = authorName
        creatorID = authorID
    }
}
