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

var currentUserID: Int?
var currentUserName: String?

class OraAPIManager {

    static let sharedInstance = OraAPIManager()
    let baseRefURL = "http://private-d9e5b-oracodechallenge.apiary-mock.com/"
    
       /// Used to register a user with the API.
       ///
       /// - parameter name:              Name of user
       /// - parameter email:             Email address of user
       /// - parameter password:          String of the submitted password
       /// - parameter confirmPassword:   Reiteration of submitted password
       /// - parameter completionHandler: Function sending a boolean to the object that initially called the registration function, used to determine whether or not the user was successfully registered.
    
       func registerUser(name: Name, email: Email, password: String, confirmPassword: String, completionHandler: @escaping (Bool) -> ()) {
        
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
 
    /// Function to ask the API to login given the input credentials.
    ///
    /// - parameter email:             Email of user
    /// - parameter password:          Password of user
    /// - parameter completionHandler: Function to be executed with a boolean indicating success or failure of login.
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
            let responseData = responseDict["data"] as! [String: AnyObject]
            currentUserID = responseData["id"] as? Int
            currentUserName = responseData["name"] as? String
            completionHandler(true)
        }
    }
    
    /// Used to fetch information about the currently logged in user.
    ///
    /// - parameter completionHandler: Function to be executed with returned user information, if API call is successful.
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
        }
    }
    
    /// Submits parameters to API in order to update the user information with the inputted paramters.
    ///
    /// - parameter name:              New name of user
    /// - parameter email:             New email of user
    /// - parameter password:          Password for verification
    /// - parameter confirm:           Confirmed password for verificaiton
    /// - parameter completionHandler: Function to be executed with a boolean indicating success or failure of edit request.
    func editProfile(name: String, email: String, password: String, confirm: String, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json; charset=utf-8", "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNDM0NDY3NDUxfQ.Or5WanRwK1WRqqf4oeIkAHRYgNyRssM3CCplZobxr4w"]
        let parameters = ["name": name, "email": email, "password": password, "confirm": confirm]
        
        Alamofire.request(baseRefURL.appending("users/me"), method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            guard response.result.isSuccess == true  else {
                print("Error parsing data returned from API")
                completionHandler(false)
                return
            }
            
            if let data = response.result.value as? [String: AnyObject] {
                if (data["success"] as? Int) == 1 {
                    completionHandler(true)
                    return
                } else {
                    completionHandler(false)
                    return
                }
            }
            completionHandler(false)
            return
        }
    }
    
    /// Retrieves the stored chats for the currently logged in user.
    ///
    /// - parameter page:              The page number for returned chats (max of 20 per page)
    /// - parameter completionHandler: Function to be executed once message chains have been returned. If retreival is unsuccessful, will send nil to the function.
    func retrieveChats(page: Int, completionHandler: @escaping ([Chat]?) -> Void) {
        let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json; charset=utf-8", "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNDM0NDY3NDUxfQ.Or5WanRwK1WRqqf4oeIkAHRYgNyRssM3CCplZobxr4w"]
        
        Alamofire.request(baseRefURL.appending("chats?q=Chat&page=\(page)&limit=20"), method: .get, headers: headers).responseJSON { (response) in
            guard response.result.isSuccess == true else {
                print("Error parsing data returned from API")
                return
            }
            
            if let data = response.result.value as? [String: AnyObject] {
                if (data["success"] as? Int) == 1 {
                    print("Successfully retrieved chats")
                    let data = response.result.value as? [String: AnyObject]
                    let chats = data?["data"] as? [[String: AnyObject]]
                    if chats != nil {
                        var chatArray: [Chat] = []
                        for chat in chats! {
                            var lastMessage: Message?
                            
                            if let message = chat["last_message"] as? [String: AnyObject] {
                                let chatID = message["chat_id"] as! Int
                                let date = (message["created"] as! String).longStyleDate()
                                let id = message["id"] as! Int
                                let contents = message["message"] as! String
                                
                                let author = message["user"] as! [String: AnyObject]
                                let authorID = author["id"] as! Int
                                let authorName = author["name"] as! String
                                
                                lastMessage = Message(newChatID: chatID, created: date, messageId: id, newMessage: contents, creatorID: authorID, creatorName: authorName)
                            }
                            
                            let created = (chat["created"] as! String).longStyleDate()
                            let id = chat["id"] as! Int
                            let name = chat["name"] as! String
                            let creator = chat["user"] as! [String:AnyObject]
                            
                            let creatorID = creator["id"] as! Int
                            let creatorName = creator["name"] as! String
                            
                            let newChat = Chat(createdDate: created, chatID: id, chatName: name, message: lastMessage!, authorName: creatorName, authorID: creatorID)
                            
                            chatArray.append(newChat)
                        }
                        print(chatArray.count)
                        completionHandler(chatArray)
                        return
                    }
                    
                    completionHandler(nil)
                    return
                } else {
                    completionHandler(nil)
                    print("Did not successfully retrieve chats")
                    return
                }
            }
        }
    }
    
    /// Retrieves information for one specific message chain
    ///
    /// - parameter id:                The ID number of the given chat
    /// - parameter page:              The page number of chats to be returned
    /// - parameter completionHandler: Function to be executed once response has been received from the API (will return nil if no messages are received)
    
    func retrieveChatInformation(id: Int, page: Int, completionHandler: @escaping ([Message]?) -> Void) {
        let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json; charset=utf-8", "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNDM0NDY3NDUxfQ.Or5WanRwK1WRqqf4oeIkAHRYgNyRssM3CCplZobxr4w"]
        
        Alamofire.request(baseRefURL.appending("chats/\(id)/messages?page=\(page)&limit=20"), method: .get, headers: headers).responseJSON { (response) in
            guard response.result.isSuccess == true else {
                print("Error parsing data returned from API")
                return
            }
            
            if let data = response.result.value as? [String: AnyObject] {
                if (data["success"] as? Int) == 1 {
                    print("Successfully retrieved chats")
                    let data = response.result.value as? [String: AnyObject]
                    guard let messages = data?["data"] as? [[String: AnyObject]] else {
                        completionHandler(nil)
                        return
                    }
                    var messageArray: [Message] = []
                    
                    for message in messages {
                        let chatID = message["chat_id"] as! Int
                        let userID = message["user_id"] as! Int
                        let messageID = message["id"] as! Int
                        let messageString = message["message"] as! String
                        let createdDate = (message["created"] as! String).longStyleDate()
                        let user = message["user"] as! [String: AnyObject]
                        let userName = user["name"] as! String
                        
                        let newMessage = Message(newChatID: chatID, created: createdDate, messageId: messageID, newMessage: messageString, creatorID: userID, creatorName: userName)
                        messageArray.append(newMessage)
                    }
                    if messageArray.count > 0 {
                        completionHandler(messageArray)
                        return
                    } else {
                        completionHandler(nil)
                        return
                    }
                } else {
                    completionHandler(nil)
                }
            }
        }
    }
    
    /// Attempts to create a message chain with the input title
    ///
    /// - parameter withTitle:         Title of the new chat.
    /// - parameter completionHandler: Function to be executed with a boolean indicating success or failure of the request to create a message chain.
    func createChat(withTitle: String,  completionHandler: @escaping (Bool) -> Void) {        let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json; charset=utf-8", "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNDM0NDY3NDUxfQ.Or5WanRwK1WRqqf4oeIkAHRYgNyRssM3CCplZobxr4w"]
        let parameters = ["name": withTitle]
        
        Alamofire.request(baseRefURL.appending("chats"), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            let data = response.result.value as? [String: AnyObject]
            guard (data?["data"] as? [String: AnyObject]) != nil else {
                completionHandler(false)
                return
            }
            guard let success = data?["success"] as? Int else {
                completionHandler(false)
                return
            }
            if success == 1 {
                completionHandler(true)
                return
            } else {
                completionHandler(false)
                return
            }
        }
    }
    
    /// Attempts to create a new message entry in an existing message chain.
    ///
    /// - parameter chatID:            ID number of the current message chain.
    /// - parameter text:              Text of the new message body
    /// - parameter completionHandler: Function to be executed with a boolean indicating success or failure of the creation attempt.
    func createMessage(chatID: Int, text: String, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json; charset=utf-8", "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNDM0NDY3NDUxfQ.Or5WanRwK1WRqqf4oeIkAHRYgNyRssM3CCplZobxr4w"]
        let parameters = ["message": text]
        
        Alamofire.request(baseRefURL.appending("chats/\(chatID)/messages"), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            let data = response.result.value as? [String: AnyObject]
            guard (data?["data"] as? [String: AnyObject]) != nil else {
                completionHandler(false)
                return
            }
            guard let success = data?["success"] as? Int else {
                completionHandler(false)
                return
            }
            if success == 1 {
                completionHandler(true)
                return
            } else {
                completionHandler(false)
                return
            }
        }
    }
}
