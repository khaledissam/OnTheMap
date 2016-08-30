//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 8/26/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

extension UdacityClient
{
    // MARK: Constants
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        
        static let parseHost = "parse.udacity.com"
        static let parsePath = "/parse/classes"
        
        static let SignUpURL = "https://www.udacity.com/account/auth#!/signup"
    }
    
    // MARK: Http method
    struct HTTPMethods {
        static let GET = "GET"
        static let POST = "POST"
        static let DELETE = "DELETE"
    }
    
    // MARK: Methods
    struct Methods {
        static let Session = "/session"
        static let StudentLocation = "/StudentLocation"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let UserName = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        
        static let Session = "session"
        static let Id = "id"
        static let Expiration = "expiration"
        
        static let Results = "results"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
    }
}