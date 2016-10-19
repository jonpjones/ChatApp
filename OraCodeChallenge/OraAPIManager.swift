//
//  OraAPIManager.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/18/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import Foundation
import Alamofire

class OraAPIManager {
    static let sharedInstance = OraAPIManager()
    
    let baseRefURL = URL(string: "http://private-d9e5b-oracodechallenge.apiary-mock.com/")
    
    func registerUser(name: String, email: String, password: String, confirmPassword: String) {
        
        let parameters = ["name": name, "email": email, "password": password, "confirm":  confirmPassword]
        let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json; charset=utf-8"]
        
        Alamofire.request("http://private-d9e5b-oracodechallenge.apiary-mock.com/users/register", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                print("Validation Successful")
                
                
            case .failure(let error):
                print("Validation Unsuccessful - \(error)")
            }
            
            guard let responseDict = response.result.value as? [String: Any],
                let responseInt = responseDict["success"] as? Int,
                responseInt == 1 else {
                 print("Error - Failure to register.")
                    return
                }
            
                
                
            }
        }
        
    }
    
    func registerUser (){
        
        Alamofire.request("http://private-d9e5b-oracodechallenge.apiary-mock.com/", method: .post).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
            }
    
    
}

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
