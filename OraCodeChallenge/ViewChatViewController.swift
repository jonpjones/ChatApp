//
//  ViewChatViewController.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/21/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import UIKit

class ViewChatViewController: UIViewController {
    let manager = OraAPIManager.sharedInstance
    var chatID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Test"
        
        if chatID != nil {
            manager.retrieveChatInformation(id: chatID!, page: 1, completionHandler: { (messages) in
                guard messages != nil else {
                    print("No messages to display!")
                    return
                }
                print(messages)
            })
        }
    }
}
