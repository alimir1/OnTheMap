//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Ali Mir on 10/23/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    // MARK: GET Convenience Methods
    
    func getUdacityPublicUserData(completionHandlerForUserData: @escaping (_ result: UdacityUser?, _ error: Error?) -> Void) {
        
        // Specify method (if has {key})
        var method: String = Methods.UserID
        method = substituteKeyInMethod(method: method, key: UdacityClient.URLKeys.UserID, value: String(UdacityClient.sharedInstance().userID!))!
        
        // Make the request
        _ = taskForGETMethod(method: method) {
            (results, error) in
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForUserData(nil, error)
            } else {
                if let results = results as? [String : AnyObject], let user = results[JSONResponseKeys.User] as? [String : AnyObject]{
                    let firstName = user[JSONResponseKeys.FirstName]! as! String
                    let lastName = user[JSONResponseKeys.LastName]! as! String
                    let accountID = self.userID!
                    let udacityUser = UdacityUser(firstName: firstName, lastName: lastName, accountID: accountID)
                    completionHandlerForUserData(udacityUser, nil)
                } else {
                    completionHandlerForUserData(nil, NSError(domain: "getUdacityPublicUserData parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getUdacityPublicUserData"]))
                }
            }
        }
    }
    
    // MARK: POST Convenience Methods
    
    // Use Udacity’s session method to get a session ID in order to authenticate Udacity API requests
    func postUdacitySession(username: String, password: String, completionHandlerForPOSTSession: @escaping (_ successfullyPostedUdacitySession: Bool, _ error: NSError?) -> Void) {
        
        // Specify method, parameters (if any), and HTTP body
        let method = Methods.AuthenticationSession
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.Username)\": \"\(username)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        // Make the request
        _ = taskForPOSTMethod(method: method, jsonBody: jsonBody) {
            (results, error) in
            
            func sendError(errorString: String) {
                print(errorString)
                completionHandlerForPOSTSession(false, error)
            }
            
            guard let results = results as? [String : AnyObject] else {
                sendError(errorString: "No data was returned from taskForPOSTMethod.")
                return
            }
            
            guard let session = results[JSONResponseKeys.Session] as? [String : AnyObject], let account = results[JSONResponseKeys.Account] as? [String : AnyObject] else {
                sendError(errorString: "Could not get session or account info from JSON.")
                return
            }
            
            // retrieve data from JSON and assign it to the appropriate properties in this client
            if let sessionID = session[JSONResponseKeys.SessionID] as? String, let sessionExpiration = session[JSONResponseKeys.SessionExpiration] as? String, let isRegistered = account[JSONResponseKeys.UserRegistered] as? Bool, let userID = account[JSONResponseKeys.Key] as? String {
                self.sessionID = sessionID
                self.sessionExpiration = sessionExpiration
                self.isRegistered = isRegistered
                self.userID = Int(userID)!
                
                completionHandlerForPOSTSession(true, nil)
            } else {
                sendError(errorString: "Error in getting sessionID, sessionExpiration, userID, or sessionExpiration")
            }
        }
    }
}












































