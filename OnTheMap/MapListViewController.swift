//
//  MapListViewController.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 8/26/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

import UIKit

class MapListViewController: UITabBarController {
    
    
    // MARK: Life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    // MARK: Actions
    @IBAction func logout() {
        UdacityClient.sharedInstance().logout { (errorString) in
            performUIUpdatesOnMain({ 
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        
    }
    
    @IBAction func update() {
        // get student information
        UdacityClient.sharedInstance().getStudentInfo { (errorString) in
            if let error = errorString {
                performUIUpdatesOnMain({ 
                    GlobalHelperFunction.displayAlert(self, title: "Updating failed", message: error, ok: "Ok")
                })
                return
            }
            performUIUpdatesOnMain({ 
                if let controller = self.viewControllers?[1] as? ListViewController {
                    controller.tableView.reloadData()
                }
                if let controller = self.viewControllers?[0] as? MapViewController {
                    controller.updateAnnotation()
                }
            })
        }
    }
    
    @IBAction func add() {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
        
        let postingNavigationController = UINavigationController()
        postingNavigationController.pushViewController(vc, animated: false)
        
        presentViewController(postingNavigationController, animated: true, completion: nil)
    }
    
}
