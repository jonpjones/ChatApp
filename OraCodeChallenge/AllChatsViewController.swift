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
    let chatCellID = "ChatCell"
    
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
            self.chatsTableView.reloadData()
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

extension AllChatsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = sortedDates[section]
        guard datedChats[date] != nil else {
            return 0
        }
        return datedChats[date]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatsTableView.dequeueReusableCell(withIdentifier: chatCellID, for: indexPath) as! ChatTableViewCell
        let chatDate = sortedDates[indexPath.section]
        if let chat = datedChats[chatDate]?[indexPath.row] {
            cell.chatNameLabel.text = "\(chat.name) By \(chat.creatorName)"
            cell.nameAndTimeLabel.text = "\(chat.lastMessage.userName) - \(chat.lastMessage.createdDate.timeSinceDate())"
            cell.lastMessageLabel.text = chat.lastMessage.message
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = sortedDates[section]
        return date.string()
    }
}
