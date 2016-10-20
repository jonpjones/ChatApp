//
//  User.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/20/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import Foundation

struct User {
    var name: String
    var email: String
    var id: Int
    var token: String
    
    init(userName: String, userEmail: String, userID: Int, userToken: String) {
        name = userName
        email = userEmail
        id = userID
        token = userToken
    }
}
