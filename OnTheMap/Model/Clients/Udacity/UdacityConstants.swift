//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Pete Chambers on 14/02/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constants {
        
        // MARK: URLs
        static let APIScheme = "https"
        static let APIHost = "www.udacity.com"
        static let APIPath = "/api"
    }
    
    // MARK: URL Methods
    struct Methods {
        static let Session = "/session"
    }
    
    struct UdacityParameterKeys {
        
        // Login Data
        static let udacity = [username:password]
        static let username = "username"
        static let password = "password"
        static let user = "user"
        static let userId = "user_id"
    }
    
    struct ErrorMessages {
        static let UsernamePasswordError = "Login attempt failed. Ensure that your username and password are correct."
        static let NetworkConnectionError = "Login attempt failed. The internet connection appears to be offline."
    }
    
}
