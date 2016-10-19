//
//  AccountViewController.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/19/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    let manager = OraAPIManager.sharedInstance
    
    @IBOutlet weak var userTableView: UITableView!
    
    var userName: String?
    var userEmail: String?
    var userToken: String?
    var userId: Int?
    
    let userCellID = "UserCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.getCurrentUserInfo { (name, email, token, id) in
            userName = name
            userEmail = email
            userToken = token
            userId = id
        }
    }
}

extension AccountViewController: UITableViewDelegate {
    
    
}

extension AccountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: userCellID, for: indexPath) as! RegisterCell
        
        
        
        return cell
        
    }
    
}
