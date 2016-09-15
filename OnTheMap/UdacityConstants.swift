//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 8/26/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

import UIKit

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
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Order = "order"
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
    
    // MARK: Colors
    struct Colors {
        static let grey = UIColor(red: 224.0/255, green: 224.0/255, blue: 221.0/255, alpha: 1.0)
        static let darkBlue = UIColor(red: 92.0/255, green: 135.0/255, blue: 178.0/255, alpha: 1.0)
        static let disableAlpha : CGFloat = 0.5
    }
}