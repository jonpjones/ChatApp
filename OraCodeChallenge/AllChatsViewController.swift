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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatsTableView.tableFooterView = UIView()
        manager.retrieveChats(page: 1)
    }
}
