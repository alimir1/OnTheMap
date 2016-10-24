//
//  OTMClient.swift
//  On The Map
//
//  Created by Ali Mir on 10/22/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // parse student info.
    var studentLocations = [StudentLocation]()
    var uniqueKey: String? = UdacityClient.sharedInstance().accountID
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGetMethod(parameters: [String : AnyObject]?, completionHandlerForGet: @escaping (_ result : AnyObject?, _ error : Error?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, configure the request
        var request = URLRequest(url: ParseURL(parameters: parameters))
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        print("requestURL in taskForGetMethod: \(request)")
        
        // Make the request
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGet(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(error)")
                return
            }
            
            guard  let statusCode = (response as? HTTPURLResponse)?.statusCode, 200...299 ~= statusCode else {
                sendError(error: "Your request returned a status code other than 2xx! RequestUR: \(request)")
                return
            }
            
            guard let data = data else {
                sendError(error: "No data was returned by the request!")
                return
            }
            
            // Parse the data and use the data (happens in completion handler)
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandlerForGet)
        }
        
        // Start the request
        task.resume()
        
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: Data, completionHandlerForConvertData: (_ result : AnyObject?, _ error : Error?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data on JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
        
    }
    
    // create a URL from parameters
    func ParseURL(parameters: [String : AnyObject]?) -> URL {
        var components = URLComponents()
        components.scheme = ParseClient.Costants.ApiScheme
        components.host = ParseClient.Costants.ApiHost
        components.path = ParseClient.Costants.ApiPath
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedinstance = ParseClient()
        }
        return Singleton.sharedinstance
    }
    
}





























































