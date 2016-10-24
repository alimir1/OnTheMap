//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Ali Mir on 10/23/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

extension UdacityClient {
    
    // MARK: Constants
    struct Costants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: User Account
        static let UserID = "/users/{user_id}"
        
        // MARK: Authentication
        static let AuthenticationSession = "/session"
    }
    
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "user_id"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Authorization
        static let Account = "account"
        static let Session = "session"
        static let UserRegistered = "registered"
        static let Key = "key"
        static let SessionID = "id"
        static let SessionExpiration = "expiration"
        
        // MARK: Udacity Student
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
}























