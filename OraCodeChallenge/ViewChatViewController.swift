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
    @IBOutlet weak var addMessageButton: UIButton!
    
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
    
    // When the add message button is tapped, programmatically creates a UIView with a title, a textfield and a button as subviews and animates it towards the center of the screen. 
    @IBAction func addMessageButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        
        let addMessageOrigin = CGPoint(x: 0.2 * view.frame.width, y: 0.3 * view.frame.height)
        let addRect = CGRect(origin: addMessageOrigin, size: CGSize(width: 0.6 * view.frame.width, height: 160))
        let popUp = PopUp(sourceFrame: sender.frame, destFrame: addRect, superViewController: self, title: "Send a message?", textFieldPlaceholder: "Say something!")
        popUp.delegate = self
        self.view.addSubview(popUp)
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
        
        //Currently cell.orientation does not change appearance of the cell, but this can hopefully be changed to customize the appearance of different users' messages
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

extension ViewChatViewController: PopUpDelegate {
    /// Message received from the pop up confirming text was entered into the pop up's text fields.
    ///
    /// - parameter text: Text from the text field of the delegator.
    func popUpStringReceived(text: String) {
        addMessageButton.isEnabled = true
        manager.createMessage(chatID: chatID!, text: text) { (success) in
            if success {
                print("Message sent!")
            } else {
                print("Message failed to send")
            }
        }
    }
}
