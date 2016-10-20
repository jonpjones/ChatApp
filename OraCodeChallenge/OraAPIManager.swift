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
    
    func getCurrentUserInfo(completionHandler: @escaping (User?) -> Void) {
        let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json; charset=utf-8", "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNDM0NDY3NDUxfQ.Or5WanRwK1WRqqf4oeIkAHRYgNyRssM3CCplZobxr4w"]
        
        Alamofire.request(baseRefURL.appending("users/me"), headers: headers).responseJSON { (response) in
            
            guard let json = response.result.value as? [String: AnyObject] else {
                print("Error parsing API response")
                completionHandler(nil)
                return
            }
            
            guard let data = json["data"] as? [String: AnyObject] else {
                print("Error parsing nested data returned from API")
                completionHandler(nil)
                return
            }
            let name = data["name"] as! String
            let id = data["id"] as! Int
            let token = data["token"] as! String
            let email = data["email"] as! String
            
            let retrievedUser = User(userName: name, userEmail: email, userID: id, userToken: token)
            
            completionHandler(retrievedUser)
            
            
            
            
            
        
            //TODO: Parse the api response, send data to through the completion handler
            
            
            
        }
        
        
               
    }
}
