//
//  LoginViewController.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/19/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTableView: UITableView!
    
    let manager = OraAPIManager.sharedInstance
    
    var emailTextField: UITextField?
    var passwordTextField: UITextField?
    
    var email: String?
    var password: String?
    
    let loginCellID = "LoginCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func recordTextFieldInputs() {
        email = emailTextField?.text
        password = passwordTextField?.text
    }
    
    @IBAction func loginButtonTapped(_ sender: UIBarButtonItem) {
        recordTextFieldInputs()
        manager.login(email: email!, password: password!) { (success) in
            if success {
                print("Login Successful")
            } else {
                print("Login Failed")
            }
        }
    }
}

extension LoginViewController: UITableViewDelegate {
    
    
}

extension LoginViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = loginTableView.dequeueReusableCell(withIdentifier: loginCellID, for: indexPath) as! RegisterCell
        
        switch indexPath.row {
        case 0:
            cell.categoryLabel.text = "Email:"
            emailTextField = cell.categoryTextField
        case 1:
            cell.categoryLabel.text = "Password:"
            cell.categoryTextField.isSecureTextEntry = true
            passwordTextField = cell.categoryTextField
        default: break
        }
        
        return cell
    }
}
