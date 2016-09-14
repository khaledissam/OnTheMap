//
//  Utility.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 9/13/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

import UIKit

struct GlobalHelperFunction {
    
    static func openURLInBrowser(url : String) {
        let app = UIApplication.sharedApplication()
        if let url = NSURL(string: url) {
            app.openURL(url)
        }
    }
    
    static func displayAlert(vc : UIViewController, title : String, message : String, ok : String) {
        let controller = UIAlertController()
        controller.title = title
        controller.message = message
        
        // Dismiss the view controller after the user taps “ok”
        let okAction = UIAlertAction (title: ok, style: UIAlertActionStyle.Default) {
            action in
            //vc.dismissViewControllerAnimated(true, completion: nil)
        }
        controller.addAction(okAction)
        vc.presentViewController(controller, animated: true, completion:nil)
    }
}
