//
//  AllChatsViewController.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/20/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import UIKit

class AllChatsViewController: UIViewController {
    
    @IBOutlet weak var addChatButton: UIButton!
    @IBOutlet weak var chatSearchBar: UISearchBar!
    @IBOutlet weak var chatsTableView: UITableView!
    
    let manager = OraAPIManager.sharedInstance
    let chatCellID = "ChatCell"
    let viewChatSegueID = "ViewChat"
    
    var datedChats: [Date: [Chat]] = [:]
    var sortedDates: [Date] = []
    var searching: Bool = false
    var allChats: [Chat]?
    var filteredChats: [Chat]?
    var selectedChat: Chat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatsTableView.tableFooterView = UIView()
        manager.retrieveChats(page: 1) { (chats) in
            guard chats != nil else {
                print("No chats to display")
                return
            }
            self.allChats = chats!
            self.filteredChats = chats!
            self.datedChats = self.sortAndSeparateChats(chats: chats!)
            self.chatsTableView.reloadData()
        }
    }
    
    

    /// Takes an array of Chat objects and reorganizes the array in to a dictionary, with keys representing the dates on which these chats take place.
    ///
    /// - parameter chats: An array of Chat objects
    ///
    /// - returns: A dictionary with keys representing the dates on which messages were created. If two different messages took place on the same day, the value for that date key would be an array of both chats.
    func sortAndSeparateChats(chats: [Chat]) -> [Date: [Chat]]{
        var sortedArray: [Date: [Chat]] = [:]
        for chat in chats {
            if sortedArray[chat.lastMessage.createdDate] == nil {
                sortedArray[chat.lastMessage.createdDate] = [chat]
                sortedDates.append(chat.lastMessage.createdDate)
            } else {
                var chatsOnDate = sortedArray[chat.lastMessage.createdDate]
                chatsOnDate?.append(chat)
                sortedArray[chat.lastMessage.createdDate] = chatsOnDate!
            }
        }
        sortedDates = sortedArray.keys.sorted(by: { (date1, date2) -> Bool in
            return date1 > date2
        })
        return sortedArray
    }
    
    @IBAction func addChatButtonTapped(_ sender: UIButton) {
        let addChatOrigin = CGPoint(x: 0.2 * view.frame.width, y: 0.3 * view.frame.height)
        let addRect = CGRect(origin: addChatOrigin, size: CGSize(width: 0.6 * view.frame.width, height: 160))
        
        let popUp = PopUp(sourceFrame: sender.frame, destFrame: addRect, superViewController: self, title: "Add a Chat!", textFieldPlaceholder: "Chat Title")
        popUp.delegate = self
        view.addSubview(popUp)
        sender.isEnabled = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == viewChatSegueID {
            let dvc = segue.destination as! ViewChatViewController
            dvc.chatID = selectedChat?.id
            dvc.title = selectedChat?.name
        }
    }
}

extension AllChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatDate = sortedDates[indexPath.section]
        if let chat = datedChats[chatDate]?[indexPath.row] {
            selectedChat = chat
            self.performSegue(withIdentifier: viewChatSegueID, sender: self)
        }
    }
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

extension AllChatsViewController: UISearchBarDelegate {
    // If the user changes the text in the search field, then the filtered chat array is created that contains the members of the allChats array that contain the text being searched for in the title of the chat.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            filteredChats = allChats?.filter({ (chat) -> Bool in
                return chat.name.contains(searchText)
            })
            datedChats = sortAndSeparateChats(chats: filteredChats!)
            chatsTableView.reloadData()
        } else {
            datedChats = sortAndSeparateChats(chats: allChats!)
            chatsTableView.reloadData()
        }
    }
}

extension AllChatsViewController: PopUpDelegate {
    
    /// Message received from the pop up confirming text was entered into the pop up's text fields.
    ///
    /// - parameter text: Text from the text field of the delegator.
    func popUpStringReceived(text: String) {
        addChatButton.isEnabled = true
        if text.characters.count > 0 {
            manager.createChat(withTitle: text) { (success) in
                if success {
                    print("Successfully created a chat")
                } else {
                    print("Chat creation failed!")
                }
            }
        }
    }
}
