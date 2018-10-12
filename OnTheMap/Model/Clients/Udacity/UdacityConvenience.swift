//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Pete Chambers on 01/03/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func authenticateUser(username: String, password: String, completionHandlerForAuthenticateUser: @escaping (_ success:Bool, _ error:String) -> Void) {
    
        taskForPOSTSession(username: username, password: password) { (data, error) in
       
            guard (error == nil) else {
            
                print("GUARD in ERROR: MESSAGE: \(error!.localizedDescription)")
             
                completionHandlerForAuthenticateUser(false, UdacityClient.ErrorMessages.NetworkConnectionError)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
              
                print("GUARD in DATA: MESSAGE (Username or Password is incorrect).")
                
                completionHandlerForAuthenticateUser(false, UdacityClient.ErrorMessages.UsernamePasswordError)
                return
            }
            
            /*  Parse the data */
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("taskForPOSTSession: Failed to parse data.")
                completionHandlerForAuthenticateUser(false, "Failed to parse data.")
                return
            }
            
            // Extract 'account' dictionary
            guard let account = parsedResult["account"] as? [String:AnyObject] else {
                completionHandlerForAuthenticateUser(false, "No valid account dictionary in parsed JSON data")
                return
            }
            
            // Extract account 'key' and save in accountKey
            guard let myAccountKey = account["key"] as? String else {
                completionHandlerForAuthenticateUser(false,"No valid key in account dictionary.")
                return
            }
            
            print("account key: \(myAccountKey)")
            self.accountKey = myAccountKey
            
            // Extract 'session' dictionary
            guard let session = parsedResult["session"] as? [String:AnyObject] else {
                completionHandlerForAuthenticateUser(false, "No valid session dictionary in pasrsed JSON data.")
                return
            }
            
            // Extract session 'id' and save in session ID
            guard let mySessionID = session["id"] as? String else {
                completionHandlerForAuthenticateUser(false, "No valid id in session dictinary.")
                return
            }
            
            // Store session 'id'
            print("session id: \(mySessionID)")
            self.sessionID = mySessionID
            
            completionHandlerForAuthenticateUser(true, "")
        }
    }
    
    func gettingPublicUserData(completionHandlerForGETPublicUserData: @escaping (_ success:Bool, _ error:String)->Void) {
        
        taskforGETtingPublicUserData(userID: self.accountKey) {  (data, error) in
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandlerForGETPublicUserData(false, "No raw JSON data available to attempt JSONSerialization.")
                return
            }
            
            print("print 'data' for getPublicUserData: \(data)")
            
            /*  Parse the data */
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                print("taskForGETPublicUserData: Failed to parse data")
                completionHandlerForGETPublicUserData(false, "Failed to parse data.")
                return
            }
            
            // Extract 'user' dictionary
            guard let user = parsedResult["user"] as? [String:AnyObject] else {
                completionHandlerForGETPublicUserData(false, "No valid 'user' dictionary in parsed JSON data")
                return
            }
            
            // Extract account 'last_name' and save in lastName
            guard let lastName = user["last_name"] as? String else {
                completionHandlerForGETPublicUserData(false,"No valid 'last_name' key in 'user' dictionary.")
                return
            }
            
            // Store last_name' 'key'
            print("lastName: \(lastName)")
            self.lastName = lastName
            
            // Extract user 'first_name' and save in firstName
            guard let firstName = user["first_name"] as? String else {
                completionHandlerForGETPublicUserData(false, "No valid 'first_name' key in 'user' dictinary.")
                return
            }
            
            // Store user 'firstName'
            print("firstName: \(firstName)")
            self.firstName = firstName
            
            completionHandlerForGETPublicUserData(true, "")
        }
    }

}
