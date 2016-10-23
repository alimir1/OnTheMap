//
//  OTMConstants.swift
//  On The Map
//
//  Created by Ali Mir on 10/22/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

extension ParseClient {
    // MARK: JSON Response Keys
    
    struct Costants {
        // MARK: API Key
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
    }
    
    struct ParameterKeys {
        static let Order = "order"
        static let Skip = "skip"
        static let Limit = "limit"
        static let Where = "where"
    }
    
    struct JSONResponseKeys {

        // MARK: Account
        static let AccountisRegistered = "registered"
        static let AccontKey = "key"
        
        // MARK: Authorization
        static let SessionID = "id"
        static let SessionExpirationDateAndTime = "expiration"
        
        // MARK: Students
        static let StudentFirstName = "firstName"
        static let StudentLastName = "lastName"
        static let StudentMediaURL = "mediaURL"
        static let StudentObjectID = "objectId"
        static let StudentUniqueKey = "uniqueKey"
        static let StudentLatitude = "latitude"
        static let StudentLongitude = "longitude"
        static let StudentLocationName = "mapString"
        static let StudentCreationDateAndTime = "createdAt"
        static let StudentUpdateTimeAndTime = "updatedAt"
    }
    
}
