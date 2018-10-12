//
//  UserLocation.swift
//  OnTheMap
//
//  Created by Pete Chambers on 27/03/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation

struct UserLocation {
    
    // MARK: Properties
    
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    var createdAt: String
    var updatedAt: String
    
    // MARK: Initializers
    
    init(dictionary: [String: AnyObject]) {
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
        createdAt = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as! String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as! String
        
    }
    
    struct UserData {
        static var uniqueKey = UdacityClient.sharedInstance().accountKey
        static var firstName = UdacityClient.sharedInstance().firstName
        static var lastName = UdacityClient.sharedInstance().lastName
        static var objectId = ""
        static var latitude = 0.0
        static var longitude = 0.0
        static var mapString = ""
        static var mediaURL = ""
        
    }
    
    // MARK: User Location Dictionary
    static var userLocationDictionary : [String: AnyObject] = [
        "objectId" : UserData.objectId as AnyObject,
        "uniqueKey": UserData.uniqueKey as AnyObject,
        "firstName": UserData.firstName as AnyObject,
        "lastName" : UserData.lastName as AnyObject,
        "latitude" : UserData.latitude as AnyObject,
        "mapString": UserData.mapString as AnyObject,
        "mediaURL": UserData.mediaURL as AnyObject
    ]
    
    static func userLocationFromResults(_ results: [[String:AnyObject]]) -> [UserLocation] {
        
        var userLocations = [UserLocation]()
        
        for result in results {
            userLocations.append(UserLocation(dictionary: result))
        }
        
        return userLocations
    }
    
    // MARK: New User Location
    struct NewUserLocation {
        static var mapString = ""
        static var mediaURL = ""
        static var latitude = 0.0
        static var longitude = 0.0
    }
}
