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
    
    let registerCellID = "RegisterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIBarButtonItem) {
        
        
    }
    
    @IBAction func registerButtonTapped(_ sender: UIBarButtonItem) {
        
        
    }

    func recordTextFieldInputs(textField: UITextField) {
        if textField.hasText {
            switch textField {
            case nameTextField!: name = textField.text
            case emailTextField!: email = textField.text
            case passwordTextField!: password = textField.text
            case confirmTextField!: confirm = textField.text
            default: break
            }
        }
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
        cell.categoryTextField.delegate = self
        return cell
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        recordTextFieldInputs(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        recordTextFieldInputs(textField: textField)
        return true
    }
}
