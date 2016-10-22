//
//  ViewChatViewController.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/21/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import UIKit

class ViewChatViewController: UIViewController {
    
    @IBOutlet weak var messageTableView: UITableView!
    
    let manager = OraAPIManager.sharedInstance
    let yourMessageCellID = "YourMessageCell"
    let otherMessageCellID = "OtherMessageCell"
    var sortedMessages: [Message]?
    
    var chatID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chatID != nil {
            manager.retrieveChatInformation(id: chatID!, page: 1, completionHandler: { (messages) in
                guard messages != nil else {
                    print("No messages to display!")
                    return
                }
                self.sortedMessages = messages?.sorted(by: { $0.createdDate > $1.createdDate })
                
                DispatchQueue.main.async {
                    self.messageTableView.reloadData()
                }
            })
        }
    }
}

extension ViewChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sortedMessages?.count != nil else {
            return 0
        }
        return sortedMessages!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseIdentifier: String!
        let message = sortedMessages?[indexPath.row]
        
        if message?.userID != currentUserID! {
            reuseIdentifier = otherMessageCellID
        } else {
            reuseIdentifier = yourMessageCellID
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessageTableViewCell
        
        cell.messageLabel.text = message?.message
        cell.authorAndDateLabel.text = "\(message!.userName) - \(message!.createdDate.timeSinceDate())"
        
        if message?.userID != currentUserID {
            cell.orientation = .Left
        } else {
            cell.orientation = .Right
        }
        
        
        return cell
    }
}

extension ViewChatViewController: UITableViewDelegate {
    
}
