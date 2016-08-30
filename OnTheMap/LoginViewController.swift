//
//  ViewController.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 8/25/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var debugTextLabel : UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton : UIButton!
    @IBOutlet weak var iconImage : UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    private var keyboardOnScreen = false
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configureTextField(usernameTextField)
        configureTextField(passwordTextField)
        setUIEnabled(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotification(UIKeyboardWillShowNotification, selector: #selector(keyboardWillShow))
        subscribeToNotification(UIKeyboardWillHideNotification, selector: #selector(keyboardWillHide))
        subscribeToNotification(UIKeyboardDidShowNotification, selector: #selector(keyboardDidShow))
        subscribeToNotification(UIKeyboardDidHideNotification, selector: #selector(keyboardDidHide))
        setUIEnabled(true)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Login
    @IBAction func loginPressed(sender: AnyObject) {
        
        userDidTapView(self)
        
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

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y = -keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y = 0
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(usernameTextField)
        resignIfFirstResponder(passwordTextField)
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
            loginButton.alpha = 0.5
            signupButton.alpha = 0.5
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

    
    private func configureTextField(textField: UITextField) {
        textField.delegate = self
    }
    
}


// MARK: - LoginViewController (Notifications)
extension LoginViewController {
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}