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
    func getMultipleStudentLocations(parameters: [String : AnyObject]? = nil, completionHandlerForGETMultipleStudentLocations: @escaping (_ result: [StudentLocation]?, _ error: Error?) -> Void) {

        // Make the request
        _ = taskForGetMethod(parameters: parameters){
            (results, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGETMultipleStudentLocations(nil, error)
            } else {
                if let results = results as? [String : AnyObject], let studentLocations = results[JSONResponseKeys.Results] as? [[String : AnyObject]]{
                    self.studentLocations = StudentLocation.studentLocationsFromResults(results: studentLocations)
//                    completionHandlerForGETMultipleStudentLocations(udacityUser, nil)
                } else {
                    completionHandlerForGETMultipleStudentLocations(nil, NSError(domain: "getMultipleStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse data getMultipleStudentLocations"]))
                }
            }
        }
    
    }
}
