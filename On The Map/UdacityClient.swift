//
//  UdacityClient.swift
//  On The Map
//
//  Created by Ali Mir on 10/23/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // user info
    var accountID: String? = nil
    var udacityUser: UdacityUser? = nil
    
    // authentication state
    var isRegistered: Bool? = nil
    var sessionID: String? = nil
    var sessionExpiration: String? = nil
    
    // httpMethod types
    enum HttpMethods: String {
        case POST, DELETE
    }
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(method: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {

        /* Build the URL, Configure the request */
        let request = URLRequest(url: UdacityURL(withPathExtension: method))
        
        print("request url: \(request)")
        
        /* Make the request */
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , 200...299 ~= statusCode  else {
                sendError(error: "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(error: "No data was returned by the request!")
                return
            }
            
            /* Don't include first 5 characters in data (those characters are for Udacity security purposes) */
            let range = Range(uncheckedBounds: (lower: 5, upper: data.count))
            let newData = data.subdata(in: range) /* subset response data! */
            
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data: newData, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTOrDeleteMethod(httpMethod: HttpMethods, method: String, jsonBody: String? = nil, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, configure the request
        let requestURL = UdacityURL(withPathExtension: method)
        var request = URLRequest(url: requestURL)
        
        if httpMethod == .POST {
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonBody?.data(using: .utf8)
        } else if httpMethod == .DELETE {
            request.httpMethod = "DELETE"
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        
        // Make the request
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTOrDeleteMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: There shouldn't be any request errors
            guard (error == nil) else {
                // FIXME: - Alert view stating that there was a problem (network most likely...?)
                sendError(error: "There was a request error: \(error)")
                return
            }
            
            // GUARD: Response status code should be in 2xx range
            guard let responseStatusCode = (response as? HTTPURLResponse)?.statusCode, 200...299 ~= responseStatusCode else {
                sendError(error: "Status Code not in 2xx range: \((response as? HTTPURLResponse)?.statusCode), URL: \(requestURL)")
                return
            }
            
            // GUARD: Data should not be nil
            guard let data = data else {
                sendError(error: "Data was not returned.")
                return
            }
            
            /* Don't include first 5 characters in data (those characters are for Udacity security purposes) */
            let range = Range(uncheckedBounds: (lower: 5, upper: data.count))
            let newData = data.subdata(in: range) /* subset response data! */
            
            // Parse the data and use the data (happens in completion handler)
            self.convertDataWithCompletionHandler(data: newData, completionHandlerForConvertData: completionHandlerForPOST)
            
        }
        
        // Start the request
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // create a URL from parameters and path extensions
    private func UdacityURL(withPathExtension: String) -> URL {
        var components = URLComponents()
        components.scheme = UdacityClient.Costants.ApiScheme
        components.host = UdacityClient.Costants.ApiHost
        components.path = UdacityClient.Costants.ApiPath + (withPathExtension)
        
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            print("Error in converting data object to JSON: \(error)")
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            return
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}



















