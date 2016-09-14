//
//  ViewController.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 8/25/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: KeyboardViewController {
    
    // MARK: Outlets
    @IBOutlet weak var debugTextLabel : UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton : UIButton!
    @IBOutlet weak var iconImage : UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Actions
    @IBAction func userDidTapView(sender: AnyObject) {
        resignAll()
    }
    
    
    // MARK: Life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

        configureTextFields([usernameTextField,passwordTextField], viewOnKeyboard: nil, distToKeyBoard: 0)
        setUIEnabled(true)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: Login
    @IBAction func loginPressed(sender: AnyObject) {
        
        resignAll()
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            displayError("Username or Password Empty.")
        } else {
            setUIEnabled(false)
            
            UdacityClient.sharedInstance().getSessionID(usernameTextField.text!, password: passwordTextField.text!, completionHandler: { (errorString) in
                performUIUpdatesOnMain({
                    if errorString == nil {
                        self.completeLogin()
                    } else {
                        self.displayError(errorString)
                    }
                })
            })
        }
    }
    
    private func completeLogin() {
        self.setUIEnabled(true)
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationController") as! UINavigationController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func signUP(sender: AnyObject) {
        let authorizationURL = NSURL(string: UdacityClient.Constants.SignUpURL)
        let request = NSURLRequest(URL: authorizationURL!)
        let signUpVC = storyboard!.instantiateViewControllerWithIdentifier("UdacitySignUpViewController") as! UdacitySignUpViewController
        signUpVC.urlRequest = request
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(signUpVC, animated: false)
        
        performUIUpdatesOnMain {
            self.presentViewController(webAuthNavigationController, animated: true, completion: nil)
        }
    }
    
}


// MARK: - LoginViewController (Configure UI)

extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        usernameTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        debugTextLabel.enabled = enabled
        signupButton.enabled = enabled
        activityIndicator.hidden = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
            signupButton.alpha = 1.0
            activityIndicator.stopAnimating()
            
        } else {
            loginButton.alpha = UdacityClient.Colors.disableAlpha
            signupButton.alpha = UdacityClient.Colors.disableAlpha
            activityIndicator.startAnimating()
        }
    }
    
    private func displayError(errorString: String?) {
        self.setUIEnabled(true)
        if let errorString = errorString {
            let controller = UIAlertController()
            controller.title = "Login Failed"
            controller.message = errorString
            
            // Dismiss the view controller after the user taps “ok”
            let okAction = UIAlertAction (title:"ok", style: UIAlertActionStyle.Default) {
                action in self.dismissViewControllerAnimated(true, completion: nil)
            }
            controller.addAction(okAction)
            self.presentViewController(controller, animated: true, completion:nil)
        }
    }

}
