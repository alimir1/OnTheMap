//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Ali Mir on 10/23/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: POST Convenience Methods
    
    // Use Udacity’s session method to get a session ID in order to authenticate Udacity API requests
    func postUdacitySession(username: String, password: String, completionHandlerForPOSTSession: @escaping (_ sessionID: Int?, _ error: NSError?) -> Void) {
        
        // Specify method, parameters (if any), and HTTP body
        let method = Methods.AuthenticationSession
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.Username)\": \"\(username)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        // Make the request
        _ = taskForPOSTMethod(method: method, jsonBody: jsonBody) {
            (results, error) in
            
            func sendError(errorString: String) {
                print(errorString)
                completionHandlerForPOSTSession(nil, error)
            }
            
            guard let results = results as? [String : AnyObject] else {
                sendError(errorString: "No data was returned from taskForPOSTMethod.")
                return
            }
            
            /*
             // user info
             var userID: Int? = nil
             
             // authentication state
             var isRegistered: Bool? = nil
             var sessionID: String? = nil
             var sessionExpiration: String? = nil
            */
            
            if let session = results[JSONResponseKeys.Session] as? [String : AnyObject], let sessionID = session[JSONResponseKeys.SessionID] as? String, let sessionExpiration = session[JSONResponseKeys.SessionExpiration] as? String {
                print("sessionID: \(sessionID)")
                print("sessionExpiration: \(sessionExpiration)")
                
                
//                completionHandlerForPOSTSession(Int(sessionID), nil)
            } else {
                sendError(errorString: "Unable to get UserID from the JSON file")
            }
        }
    }
}












































