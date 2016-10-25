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
        let parameters = [ParameterKeys.Order : ParameterKeys.UpdatedAt]
        
        // Make the request
        _ = taskForGetMethod(parameters: parameters as [String : AnyObject]?){
            (results, error) in
            
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
}
