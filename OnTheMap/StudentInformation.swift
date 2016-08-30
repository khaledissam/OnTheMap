//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 8/26/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//


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
    
    // MARK: Initializers
    
    // construct a TMDBMovie from a dictionary
    init?(dictionary: [String:AnyObject]) {
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
        guard let mediaURL = dictionary[UdacityClient.JSONResponseKeys.MediaURL] as? String else {
            return nil
        }
        guard let latitude = dictionary[UdacityClient.JSONResponseKeys.Latitude] as? Double else {
            return nil
        }
        guard let longitude = dictionary[UdacityClient.JSONResponseKeys.Longitude] as? Double else {
            return nil
        }
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func studentInfoFromResults(results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var info = [StudentInformation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            if let studentinfo = StudentInformation(dictionary: result) {
                info.append(studentinfo)
            }
        }
        
        return info
    }
}