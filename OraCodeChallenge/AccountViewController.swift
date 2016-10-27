//
//  AccountViewController.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/19/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    
    let manager = OraAPIManager.sharedInstance
    var currentUser: User?
    
    var updatedName: String?
    var updatedEmail: String?
    var password: String?
    var confirm: String?
    
    var nameTextField: UITextField?
    var emailTextField: UITextField?
    var passwordTextField: UITextField?
    var confirmTextField: UITextField?
    
    let userCellID = "UserCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.tableFooterView = UIView()
        manager.getCurrentUserInfo { (user) in
            guard user != nil else {
                //TODO: Handle failure case here
                return
            }
            self.currentUser = user!
            
            DispatchQueue.main.async {
                self.userTableView.reloadData()
            }
        }
    }
    //When the save button is tapped, the user variables are to the contents of their corresponding text fields. If the password field is populated and matches the contents of the confirm field, then all of the information is submitted to the API create a new user.
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        updateUserWithInputs()
        if password != confirm || password!.characters.count < 1 {
            print("Passwords do not match.")
            sender.isEnabled = true
            return
        }
        
        manager.editProfile(name: updatedName!, email: updatedEmail!, password: password!, confirm: confirm!) { (success) in
            if success {
                print("Successfully edited profile")
            } else {
                print("Profile not successfully saved!")
            }
            sender.isEnabled = true
        }
    }
    
    // Updates user variables with contents of associated text fields
    func updateUserWithInputs() {
        updatedName = nameTextField?.text
        updatedEmail = emailTextField?.text
        password = passwordTextField?.text
        confirm = confirmTextField?.text
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
                cell.categoryTextField.text = currentUser!.email
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
