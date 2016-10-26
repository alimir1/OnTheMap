//
//  StudentLocation.swift
//  On The Map
//
//  Created by Ali Mir on 10/22/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//


// MARK: - StudentInformation

struct StudentInformation {
    
    // MARK: Properties
    let objectID: String?
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let latitude: Double
    let longitude: Double
    let mediaURL: String
    
    // MARK: Initializers
    
    // construct a StudentInformation from a dictionary
    init(dictionary: [String : AnyObject]) {
        self.objectID = dictionary[ParseClient.JSONResponseKeys.StudentObjectID] as? String
        self.uniqueKey = dictionary[ParseClient.JSONResponseKeys.StudentUniqueKey] as!  String
        self.firstName = dictionary[ParseClient.JSONResponseKeys.StudentFirstName] as! String
        self.lastName = dictionary[ParseClient.JSONResponseKeys.StudentLastName] as! String
        self.mapString = dictionary[ParseClient.JSONResponseKeys.StudentMapString] as! String
        self.latitude = dictionary[ParseClient.JSONResponseKeys.StudentLatitude] as! Double
        self.longitude = dictionary[ParseClient.JSONResponseKeys.StudentLongitude] as! Double
        self.mediaURL = dictionary[ParseClient.JSONResponseKeys.StudentMediaURL] as! String
    }
    
    // construct a StudentInformation from properties
    init(objectID: String?, uniqueKey: String, firstName: String, lastName: String, mapString: String, latitude: Double, longitude: Double, mediaURL: String) {
        self.objectID = objectID
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.latitude = latitude
        self.longitude = longitude
        self.mediaURL = mediaURL
    }
    
    static func studentInformationsFromResults(results: [[String : AnyObject]]) -> [StudentInformation] {
        var students = [StudentInformation]()

        // iterate through array of dictionaries, each StudentLocation is a dictionary
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }
}

// MARK: - StudentInformation: Equatable

extension StudentInformation: Equatable {}

func ==(lhs: StudentInformation, rhs: StudentInformation) -> Bool {
    return lhs.uniqueKey == rhs.uniqueKey
}





