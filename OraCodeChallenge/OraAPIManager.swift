//
//  OraAPIManager.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/18/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import Foundation
import Alamofire

typealias Email = String
typealias Name = String
typealias Token = String
typealias ID = Int

class OraAPIManager {

    static let sharedInstance = OraAPIManager()
    
    let baseRefURL = "http://private-d9e5b-oracodechallenge.apiary-mock.com/"
    
    func registerUser(name: String, email: String, password: String, confirmPassword: String, completionHandler: @escaping (Bool) -> ()) {
        
        let parameters = ["name": name, "email": email, "password": password, "confirm":  confirmPassword]
        let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json; charset=utf-8"]
        
        Alamofire.request(baseRefURL.appending("users/register"), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                print("Validation Successful")
                
            case .failure(let error):
                print("Validation Unsuccessful - \(error)")
                completionHandler(false)
                return
            }
            
            guard let responseDict = response.result.value as? [String: Any],
                let responseInt = responseDict["success"] as? Int,
                responseInt == 1 else {
                    print("Error - Failure to register.")
                    completionHandler(false)
                    return
            }
            completionHandler(true)
        }
    }
    
    func login(email: String, password: String, completionHandler: @escaping (Bool) -> ()) {
        let parameters = ["email": email, "password": password]
        let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json; charset=utf-8"]
        
        Alamofire.request(baseRefURL.appending("users/login"), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                print("Successful Response from API")
                
            case .failure(let error):
                print("Login Validation Unsuccessful - \(error)")
                completionHandler(false)
                return
            }
            
            print(response.result.value)
            guard let responseDict = response.result.value as? [String: Any],
                let responseInt = responseDict["success"] as? Int,
                responseInt == 1 else {
                    print("Error - Failure to register.")
                    completionHandler(false)
                    return
            }
            completionHandler(true)
        }
    }
    
    func getCurrentUserInfo(completionHandler: (Name, Email, Token, ID) -> Void) {
        
        
    }
}
