//
//  UdacitySignUpViewController.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 8/26/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

import UIKit


// MARK: - UdacitySignUpViewController: UIViewController
class UdacitySignUpViewController: UIViewController {
    
    // MARK: Properties
    
    var urlRequest: NSURLRequest? = nil
    
    // MARK: Outlets
    
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        navigationItem.title = "Udacity SignUp"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(cancelSignup))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let urlRequest = urlRequest {
            webView.loadRequest(urlRequest)
        }
    }
    
    // MARK: Cancel Auth Flow
    
    func cancelSignup() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UdacitySignUpViewController: UIWebViewDelegate

extension UdacitySignUpViewController: UIWebViewDelegate {
    

}
