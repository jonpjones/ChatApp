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
    
    var currentUser: User?
    
    var nameTextField: UITextField?
    var emailTextField: UITextField?
    var passwordTextField: UITextField?
    var confirmTextField: UITextField?
    
    let userCellID = "UserCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.getCurrentUserInfo { (user) in
            guard user != nil else {
                //TODO: Handle failure case here
                return
            }
            self.currentUser = user!
        }
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        
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
        
        switch indexPath.row {
        case 0:
            cell.categoryLabel.text = "Name:"
            if currentUser != nil {
                cell.categoryTextField.text = currentUser!.name
            }
            nameTextField = cell.categoryTextField
            
        case 1:
            cell.categoryLabel.text = "Email:"
            if currentUser != nil {
                cell.categoryTextField.text = currentUser!.name
            }
            emailTextField = cell.categoryTextField
            
        case 2:
            cell.categoryLabel.text = "Password:"
            passwordTextField = cell.categoryTextField
            cell.categoryTextField.isSecureTextEntry = true
            
        case 3:
            cell.categoryLabel.text = "Confirm:"
            confirmTextField = cell.categoryTextField
            cell.categoryTextField.isSecureTextEntry = true
        default: break
        }
        return cell
    }
    
}
