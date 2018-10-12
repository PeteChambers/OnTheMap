//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Pete Chambers on 01/03/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension ParseClient {

    // MARK: Function for extracting first and last name from public user data
    func getAStudentLocation(completionHandlerForGETAStudentLocation: @escaping (_ success:Bool, _ error:String)->Void) {
    
        taskForGETAStudentLocation() {  (data, error) in
            
            guard (error == nil) else {
                print("Error from taskForGETAStudentLocation: \(String(describing: error?.localizedDescription))")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                // if no data then print error and set completionHandler for data as false
                print("Error from taskForGETAStudentLocation: \(String(describing: error?.localizedDescription))")
                completionHandlerForGETAStudentLocation(false, "No raw JSON data available to attempt JSONSerialization.")
                return
            }
            /*  Parse the data */
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                completionHandlerForGETAStudentLocation(false, "Failed to parse data.")
                return
            }
            
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                completionHandlerForGETAStudentLocation(false, "No valid 'results' dictionary in parsed JSON data")
                print("ERROR: Could not parse values from the 'results' key for func getAStudentLocation()")
                return
            }
            
            guard !(results.isEmpty) else {

                UserLocation.UserData.objectId = ""
                completionHandlerForGETAStudentLocation(true, "")
                return
            }
            
            guard let objectId = results[0]["objectId"] as? String else {
                return
            }
            
            UserLocation.UserData.objectId = objectId
            guard let mapString = results[0]["mapString"] as? String else {
                return
            }
            
            UserLocation.UserData.mapString = mapString
            guard let mediaURL = results[0]["mediaURL"] as? String else {
                return
            }
            
            UserLocation.UserData.mediaURL = mediaURL
            guard let latitude = results[0]["latitude"] as? Double else {
                return
            }
            
            UserLocation.UserData.latitude = latitude
            guard let longitude = results[0]["longitude"] as? Double else {
                return
            }
            
            UserLocation.UserData.longitude = longitude
            completionHandlerForGETAStudentLocation(true, "")
        }
    }
    
    // MARK: Function for extracting first and last name from public user data
    func getStudentLocations(completionHandlerForGET: @escaping (_ success:Bool, _ error:String)->Void) {
        
        let _ = taskForGETingStudentLocations() {  (data, error) in
          
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("Error from taskForGETAStudentLocation: \(String(describing: error?.localizedDescription))")
                completionHandlerForGET(false, "No raw JSON data available to attempt JSONSerialization.")
                return
            }
            
            /*  Parse the data */
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                print("taskForGETStudentLocations: Failed to parse data")
                completionHandlerForGET(false, "Failed to parse data.")
                return
            }
            
            // Extract 'results' ArrayOfDictionary
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                completionHandlerForGET(false, "No valid 'results' dictionary in parsed JSON data")
                return
            }
   
            var arrayOfLocationsDictionaries = results
            
            guard UserLocation.UserData.objectId != "" else {
                
                // MARK: Store 100 student locations
                arrayOfStudentLocations = StudentLocation.studentLocationsFromResults(arrayOfLocationsDictionaries)
                completionHandlerForGET(true, "")
                return
            }
            
            // Add user location to list of 100 student locations
            arrayOfLocationsDictionaries.insert(UserLocation.userLocationDictionary, at: 0)
            
            //  MARK: Store 100 student + user location)
            arrayOfStudentLocations = StudentLocation.studentLocationsFromResults(arrayOfLocationsDictionaries)
            completionHandlerForGET(true, "")
        }
    }
    
    // MARK: POST Convenience Methods
    
    func postAStudentLocation(newUserMapString: String, newUserMediaURL: String, newUserLatitude: Double, newUserLongitude: Double, completionHandlerForLocationPOST: @escaping (_ success:Bool, _ error:String) -> Void) {
        
        /* Set the parameters */
        let jsonBody = "{\"uniqueKey\": \"\(UserLocation.UserData.uniqueKey)\", \"firstName\": \"\(UserLocation.UserData.firstName)\", \"lastName\": \"\(UserLocation.UserData.lastName)\",\"mapString\":  \"\(newUserMapString)\", \"mediaURL\": \"\(newUserMediaURL)\",\"latitude\": \(newUserLatitude), \"longitude\":  \(newUserLongitude)}"
        
        print("jsonBody for POST: \(jsonBody)")
        
        /* Make the request */
        let _ = taskForPOSTingAStudentLocation(jsonBody: jsonBody) { (results, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLocationPOST(false, "Error: Could not POST new user location")
                print(error)
                
                print("POST Error?: \(error)")
            } else {
                completionHandlerForLocationPOST(true, "Successful POST")
            }
        }
    }
    
    // MARK: PUT Convenience Methods
    
    func putAStudentLocation(newUserMapString: String, newUserMediaURL: String, newUserLatitude: Double, newUserLongitude: Double, completionHandlerForLocationPUT: @escaping (_ success:Bool, _ error:String) -> Void) {
        
        /* Set the parameters */
        let jsonBody = "{\"uniqueKey\": \"\(UserLocation.UserData.uniqueKey)\", \"firstName\": \"\(UserLocation.UserData.firstName)\", \"lastName\": \"\(UserLocation.UserData.lastName)\",\"mapString\":  \"\(newUserMapString)\", \"mediaURL\": \"\(newUserMediaURL)\",\"latitude\": \(newUserLatitude), \"longitude\":  \(newUserLongitude)}"
        
        print("jsonBody for PUT: \(jsonBody)")
        
        /* Make the request */
        let _ = taskForPUTtingAStudentLocation(jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLocationPUT(false, "Error: Could not PUT new user location")
                print(error)
                print("PUT Error?: \(error)")
            } else {
                print("Are we getting here?")
                
                completionHandlerForLocationPUT(true, "Successful PUT")
            }
        }
    } 
}

