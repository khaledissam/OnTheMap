//
//  DisplayAlert.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 9/7/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

import UIKit

func displayAlert(vc : UIViewController, title : String, message : String, ok : String) {
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