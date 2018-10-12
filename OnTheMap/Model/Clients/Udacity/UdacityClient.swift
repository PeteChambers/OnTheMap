//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Pete Chambers on 30/01/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    var accountKey = ""
    var sessionID = ""
    var firstName = ""
    var lastName = ""
    
    // Shared session
    var session = URLSession.shared
    
    // MARK: POSTing a session
    func taskForPOSTSession(username: String, password: String, completionHandlerForPOSTSession: @escaping (_ data: Data?, _ error: Error? ) -> Void) {
        
        // Build the URL, Configure the request */
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error Message: \(String(describing: error!.localizedDescription))")
                completionHandlerForPOSTSession(nil, error!)
                return
            }
            func displayError(_ error: String) {
                print(error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                completionHandlerForPOSTSession(nil, error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                displayError("Your request returned a status code other than 2xx!")
                completionHandlerForPOSTSession(nil, error)
                
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                completionHandlerForPOSTSession(nil, error)
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            print("Root JSON for taskForPOSTSession: " + String(data: newData, encoding: .utf8)!)
            
            /* Parse the data and use the data (happens in completion handler) */
            completionHandlerForPOSTSession(newData, nil)
        }
        task.resume()
    }
    
    // MARK: GETting Public User Data
    func taskforGETtingPublicUserData(userID:String, completionHandlerForGETPublicUserData:@escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        /* Build the URL and configure the request */
        let methodURL = "https://www.udacity.com/api/users/\(userID)"
        print("userID: \(userID)")
        print("GET URL: \(methodURL)")
        
        let request = URLRequest(url: URL(string: methodURL)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandlerForGETPublicUserData(nil, error!)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            print("Root JSON for taskForGETPublicUserData: " + String(data: newData!, encoding: .utf8)!)
            
            /* Parse the data and use the data (happens in completion handler) */
            completionHandlerForGETPublicUserData(newData, nil)
        }
        task.resume()
    }
    
    // MARK: DELETEing a session
    func taskForDELETEingASession(completionHandlerForDELETEingASession: @escaping (_ success: Bool,_ error: Error? ) -> Void) {
        
        /* Build the URL and configure the request */
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        
        /* Make request */
        let task = session.dataTask(with: request) { data, response, error in
            
            /* GUARD: Was there an error? */
            if error != nil {
                print("Error Message: \(String(describing: error!.localizedDescription))")
                completionHandlerForDELETEingASession(false, error!)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandlerForDELETEingASession(false, error)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandlerForDELETEingASession(false, error)
                print("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            
            print("User has Successfully Logged Out")
            
            self.clearUserData()
            
            completionHandlerForDELETEingASession(true, nil)

        }
        task.resume()
    }
    
    // Function to clear user data after logout
    func clearUserData() {
        
        arrayOfStudentLocations = []
        
        UserLocation.NewUserLocation.latitude = 0.0
        UserLocation.NewUserLocation.longitude = 0.0
        UserLocation.NewUserLocation.mapString = ""
        UserLocation.NewUserLocation.mediaURL = ""
        
        UserLocation.UserData.firstName = ""
        UserLocation.UserData.lastName = ""
        UserLocation.UserData.objectId = ""
        UserLocation.UserData.uniqueKey = ""
        UserLocation.UserData.mapString = ""
        UserLocation.UserData.mediaURL = ""
        
        UserLocation.userLocationDictionary = [:]
        
    }

    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
