//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Pete Chambers on 15/03/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    static let parseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let restApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let xParseApplicationID = "X-Parse-Application-Id"
    static let xParseRESTAPIKey = "X-Parse-REST-API-Key"
    
    static let studentLocationURL = "https://parse.udacity.com/parse/classes"
    
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
   


init(dictionary: [String: AnyObject]) {
    objectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String ?? ""
    uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String ?? ""
    firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String ?? ""
    lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String ?? ""
    mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String ?? ""
    mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String ?? ""
    latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double ?? 0.0
    longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double ?? 0.0
    createdAt = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as? String ?? ""
    updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as? String ?? ""
}
    
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var studentLocations = [StudentLocation]()
        
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        return studentLocations
    }
}

var arrayOfStudentLocations = [StudentLocation]()
