//
//  OraAPIManager.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/18/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import Foundation

class OraAPIManager {
    static let sharedInstance = OraAPIManager()
    
    let baseRefURL = URL(string: "http://private-d9e5b-oracodechallenge.apiary-mock.com/")
    
    func registerUser(name: String, email: String, password: String, confirmPassword: String) {
        let registerString = "users/register"
        let registerURL = URL(string: registerString, relativeTo: baseRefURL!)
        
        var request = URLRequest(url: registerURL!)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = "{\n  \"\name\": \"\(name)\",\n  \"email\": \"\(email)\",\n  \"password\": \"\(password)\",\n  \"confirm\": \"\(confirmPassword)\"\n}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response, let data = data {
                print(response)
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Dictionary <String, AnyObject>
                    
                    
                    
                    
                } catch let error{
                    print(error)
                }
                
            } else {
                print(error)
            }
        }
        task.resume()
    }
    
    
}
