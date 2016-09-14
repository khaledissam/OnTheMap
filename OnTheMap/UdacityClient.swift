//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 8/26/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

import Foundation

class UdacityClient {
    
    // MARK: Properties
    var sessionId: String?
    var userId: String?
    var studentInfo : [StudentInformation] = []
    
    // MARK: HTTP method
    
    func taskForHTTPMethod(host: String, path: String, method: String, httpMethod : String, parameters: [String:AnyObject], jsonBody: String, completionHandler: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: tmdbURLFromParameters(parameters, withHost: host, withPath: path, withMethod: method))
        request.HTTPMethod = httpMethod
        if httpMethod == HTTPMethods.POST {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
            
        } else if httpMethod == HTTPMethods.DELETE {
            var xsrfCookie: NSHTTPCookie? = nil
            let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        
        if method == Methods.StudentLocation {
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        /* 4. Make the request */
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                completionHandler(result: nil, error: error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* subset response data! */
            if method ==  Methods.Session {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                /* 5/6. Parse the data and use the data (happens in completion handler) */
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
                
            } else {
                /* 5/6. Parse the data and use the data (happens in completion handler) */
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandler)
            }
            
            
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: String?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            completionHandlerForConvertData(result: nil, error: "Could not parse the data as JSON: '\(NSString(data: data, encoding: NSUTF8StringEncoding))'")
            return
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    // create a URL from parameters
    private func tmdbURLFromParameters(parameters: [String:AnyObject], withHost: String, withPath: String, withMethod: String) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = withHost
        components.path = withPath + withMethod
        
        if parameters.isEmpty == false {
            components.queryItems = [NSURLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = NSURLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.URL!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}