//
//  RegisterViewController.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/18/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerTableView: UITableView!
    
    var nameTextField: UITextField?
    var emailTextField: UITextField?
    var passwordTextField: UITextField?
    var confirmTextField: UITextField?
    
    var name: String?
    var email: String?
    var password: String?
    var confirm: String?
    
    let manager = OraAPIManager.sharedInstance
    let registerCellID = "RegisterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView.tableFooterView = UIView()
    }
    
    @IBAction func registerButtonTapped(_ sender: UIBarButtonItem) {
        recordTextFieldInputs()
        sender.isEnabled = false
        
        manager.registerUser(name: name!, email: email!, password: password!, confirmPassword: confirm!) { (success) in
            if success {
                print("Successfully Registered!")
                self.manager.login(email: self.email!, password: self.password!, completionHandler: { (success) in
                    if success {
                        print("Login Successful")
                        self.performSegue(withIdentifier: "LoginSuccess", sender: self)
                    } else {
                        //TODO: Handle failure case for login
                        sender.isEnabled = true
                    }
                })
            } else {
                sender.isEnabled = true
                //TODO: Handle case where registration fails
            }
        }
    }

    func recordTextFieldInputs() {
        name = nameTextField!.text
        email = emailTextField!.text
        password = passwordTextField!.text
        confirm = confirmTextField!.text
    }
}

extension RegisterViewController: UITableViewDelegate {
    
}

extension RegisterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = registerTableView.dequeueReusableCell(withIdentifier: registerCellID
            , for: indexPath) as! RegisterCell
        
        switch indexPath.row {
        case 0:
            cell.categoryLabel.text = "Name:"
            nameTextField = cell.categoryTextField
        case 1:
            cell.categoryLabel.text = "Email:"
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
