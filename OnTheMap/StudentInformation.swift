//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 8/26/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

class StudentInformationFactory {
    static func studentInfoFromDict(dictionary : [String : AnyObject]) -> StudentInformation? {
        guard let objectId = dictionary[UdacityClient.JSONResponseKeys.ObjectId] as? String else {
            return nil
        }
        guard let uniqueKey = dictionary[UdacityClient.JSONResponseKeys.UniqueKey] as? String else {
            return nil
        }
        guard let firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as? String else {
            return nil
        }
        guard let lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as? String else {
            return nil
        }
        guard let mapString = dictionary[UdacityClient.JSONResponseKeys.MapString] as? String else {
            return nil
        }
        let mediaURL = dictionary[UdacityClient.JSONResponseKeys.MediaURL] as? String
        
        guard let latitude = dictionary[UdacityClient.JSONResponseKeys.Latitude] as? Double else {
            return nil
        }
        guard let longitude = dictionary[UdacityClient.JSONResponseKeys.Longitude] as? Double else {
            return nil
        }
        
        
        var url  = ""
        if mediaURL != nil {
            url = mediaURL!
        }
        
        let info = StudentInformation(objectId: objectId, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: url, latitude: latitude, longitude: longitude)
        
        return info
    }
    
    static func studentInfoFromDicts(results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var info = [StudentInformation]()
        
        // iterate through array of dictionaries, each StudentInformation is a dictionary
        for result in results {
            if let studentinfo = studentInfoFromDict(result) {
                info.append(studentinfo)
            }
        }
        
        return info
    }
}

struct StudentInformation {
    // MARK: Properties
    
    let objectId : String
    let uniqueKey : String
    let firstName : String
    let lastName : String
    let mapString : String
    let mediaURL : String
    let latitude : Double
    let longitude : Double
}