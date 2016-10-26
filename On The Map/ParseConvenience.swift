//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Ali Mir on 10/24/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import Foundation

extension ParseClient {
    // MARK: GET Convenience Methods
    
    // get multiple student locations
    func getMultipleStudentLocations(completionHandlerForGETMultipleStudentLocations: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        /* Specify parameters */
        let parameters = [ParameterKeys.Order : "-\(ParameterKeys.UpdatedAt)"]
        
        // Make the request
        _ = taskForGetMethod(parameters: parameters as [String : AnyObject]?){ (results, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGETMultipleStudentLocations(false, error)
            } else {
                if let results = results as? [String : AnyObject], let studentInformations = results[JSONResponseKeys.Results] as? [[String : AnyObject]]{
                    self.studentInformations = StudentInformation.studentInformationsFromResults(results: studentInformations)
                    completionHandlerForGETMultipleStudentLocations(true, nil)
                } else {
                    completionHandlerForGETMultipleStudentLocations(false, NSError(domain: "getMultipleStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse data getMultipleStudentLocations"]))
                }
            }
        }
    }
    
    // MARK: POST Convenience Methods
    
    // Post a Student Location
    func postStudentLocation(isBeingOverwritten: Bool, student: StudentInformation, completionHandler: @escaping (_ success: Bool, _ objectID: String?, _ error: Error?) -> Void) {
        
        /* Specify jsonBody */
        let jsonBody = "{\"\(ParseClient.JSONResponseKeys.StudentUniqueKey)\": \"\(student.uniqueKey)\", \"\(ParseClient.JSONResponseKeys.StudentFirstName)\": \"\(student.firstName)\", \"\(ParseClient.JSONResponseKeys.StudentLastName)\": \"\(student.lastName)\",\"\(ParseClient.JSONResponseKeys.StudentMapString)\": \"\(student.mapString)\", \"\(ParseClient.JSONResponseKeys.StudentMediaURL)\": \"\(student.mediaURL)\",\"\(ParseClient.JSONResponseKeys.StudentLatitude)\": \(student.latitude), \"\(ParseClient.JSONResponseKeys.StudentLongitude)\": \(student.longitude)}"
        
        var method: String? = nil
        var httpMethod: HttpMethod
        
        if isBeingOverwritten {
            method = substituteKeyInMethod(method: ParseClient.Methods.ObjectID, key: ParseClient.URLKeys.ObjectID, value: self.currentStudentObjectID!)
            httpMethod = .PUT
        } else {
            httpMethod = .POST
        }
        
        _ = taskForPostOrPutMethod(httpMethod: httpMethod, method: method, parameters: nil, jsonBody: jsonBody) { (results, error) in
            
            guard (error == nil) else {
                completionHandler(true, nil, error)
                return
            }
            
            if let results = results as? [String : AnyObject], results.count > 0 {
                if let objectID = results[ParseClient.JSONResponseKeys.StudentObjectID] as? String {
                    self.currentStudentObjectID = objectID
                    completionHandler(true, objectID, nil)
                } else {
                    completionHandler(true, nil, nil)
                }
            } else {
                completionHandler(false, nil, NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse data getMultipleStudentLocations"]))
            }
        }
    }
}




