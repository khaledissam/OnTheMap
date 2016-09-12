//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 8/26/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

import Foundation

extension UdacityClient
{
    func getSessionID(username : String, password : String, completionHandler : (errorString : String?) -> Void) {
        
        // parameters
        let parameters : [String:AnyObject] = [:]
        
        // request
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.UserName)\": \"\(username)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        taskForHTTPMethod(Constants.ApiHost, path: Constants.ApiPath, method: Methods.Session, httpMethod: HTTPMethods.POST, parameters: parameters, jsonBody: jsonBody) {
            (result, error) in
            
            // guard
            guard (error == nil) else {
                completionHandler(errorString: error!)
                return
            }
            
            guard let account = result[JSONResponseKeys.Account] as? [String:AnyObject] else {
                completionHandler(errorString: "No account information")
                return
            }
            
            guard let session = result[JSONResponseKeys.Session] as? [String:AnyObject] else {
                completionHandler(errorString: "No session information")
                return
            }
            
            guard let registered = account[JSONResponseKeys.Registered] as? Bool else {
                completionHandler(errorString: "No registration information")
                return
            }
            
            guard let id = session[JSONResponseKeys.Id] as? String else {
                completionHandler(errorString: "No id information")
                return
            }
            
            guard let key = account[JSONResponseKeys.Key] as? String else {
                completionHandler(errorString: "No account id ")
                return
            }
            
            // check registration
            if registered == false {
                completionHandler(errorString: "User is not registered")
                return
            }
            
            // session id
            self.sessionId = id
            self.userId = key
            print("Login success: id = \(id), account = \(key)")
            completionHandler(errorString: nil)
        }
    }
    
    func logout(completionHandler : (errorString : String?) -> Void) {
        // parameters
        let parameters : [String:AnyObject] = [:]
        
        // request
        let jsonBody = ""
        
        taskForHTTPMethod(Constants.ApiHost, path: Constants.ApiPath, method: Methods.Session, httpMethod: HTTPMethods.DELETE, parameters: parameters, jsonBody: jsonBody) {
            (result, error) in
            
            // guard
            guard (error == nil) else {
                completionHandler(errorString: error!)
                return
            }
 
            print("Logout sucess")
            completionHandler(errorString: nil)
        }
    }
    
    func getStudentInfo(completionHandler : (errorString : String?) -> Void) {
        let parameters : [String:AnyObject] = [:]
        let jsonBody = ""
        
        taskForHTTPMethod(Constants.parseHost, path: Constants.parsePath, method: Methods.StudentLocation, httpMethod: HTTPMethods.GET, parameters: parameters, jsonBody: jsonBody) { (result, error) in
            
            // guard
            guard (error == nil) else {
                completionHandler(errorString: error!)
                return
            }
            
            guard let results = result[JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                completionHandler(errorString: "No results")
                return
            }
            
            self.studentInfo = StudentInformation.studentInfoFromResults(results)
            
            print("Get student information")
            
            completionHandler(errorString: nil)
        }
    }
    
    func addStudentInfo(mapString : String, mediaURL : String, latitude : Double, longitude : Double, completionHandler : (errorString : String?) -> Void) {

        // parameters
        let parameters : [String:AnyObject] = [:]
        
        // request
        if userId == nil {
            completionHandler(errorString: "No userId")
            return
        }
        let jsonBody = "{\"\(JSONBodyKeys.UniqueKey)\": \"\(userId!)\", \"\(JSONBodyKeys.FirstName)\": \"MJ\", \"\(JSONBodyKeys.LastName)\": \"Zhu\", \"\(JSONBodyKeys.MapString)\": \"\(mapString)\", \"\(JSONBodyKeys.MediaURL)\": \"\(mediaURL)\", \"\(JSONBodyKeys.Latitude)\": \(latitude), \"\(JSONBodyKeys.Longitude)\": \(longitude)}"
        print("jsonBody = \(jsonBody)")
        
        taskForHTTPMethod(Constants.parseHost, path: Constants.parsePath, method: Methods.StudentLocation, httpMethod: HTTPMethods.POST, parameters: parameters, jsonBody: jsonBody) { (result, error) in
            // guard
            guard (error == nil) else {
                completionHandler(errorString: error!)
                return
            }
            
            print("Add student info")
            completionHandler(errorString: nil)
        }
    }
    
}