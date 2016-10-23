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
        
        // MARK: API Key
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
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
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Authorization
        static let Account = "account"
        static let Session = "session"
        
        // MARK: User
        static let UserRegistered = "registered"
        static let Key = "key"
        static let SessionID = "id"
        static let SessionExpiration = "expiration"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
}























