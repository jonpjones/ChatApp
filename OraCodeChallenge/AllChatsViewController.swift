//
//  AllChatsViewController.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/20/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import UIKit

class AllChatsViewController: UIViewController {

    @IBOutlet weak var chatSearchBar: UISearchBar!
    @IBOutlet weak var chatsTableView: UITableView!
    
    let manager = OraAPIManager.sharedInstance
    
    var datedChats: [Date: [Chat]] = [:]
    var sortedDates: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatsTableView.tableFooterView = UIView()
        manager.retrieveChats(page: 1) { (chats) in
            guard chats != nil else {
                print("No chats to display")
                return
            }
            self.sortAndSeparateChats(chats: chats!)
        }
    }
    
    func sortAndSeparateChats(chats: [Chat]) {
        for chat in chats {
            if datedChats[chat.lastMessage.createdDate] == nil {
                datedChats[chat.lastMessage.createdDate] = [chat]
                sortedDates.append(chat.lastMessage.createdDate)
            } else {
                var chatsOnDate = datedChats[chat.lastMessage.createdDate]
                chatsOnDate?.append(chat)
                datedChats[chat.lastMessage.createdDate] = chatsOnDate!
            }
        }
        sortedDates = datedChats.keys.sorted(by: { (date1, date2) -> Bool in
            return date1 > date2
        })
    }
}

extension AllChatsViewController: UITableViewDelegate {
    
}
