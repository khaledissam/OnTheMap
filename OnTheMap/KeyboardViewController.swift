//
//  KeyboradViewController.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 9/13/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

import UIKit

class KeyboardViewController: UIViewController {
    
    // MARK: - Properties
    private var keyboardOnScreen = false
    private var textFields : [UITextField] = []
    private var viewOnKeyboard : UIView?
    private var distToKeyBoard: CGFloat = 40
    
    // MARK: - Life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotification(UIKeyboardWillShowNotification, selector: #selector(keyboardWillShow))
        subscribeToNotification(UIKeyboardWillHideNotification, selector: #selector(keyboardWillHide))
        subscribeToNotification(UIKeyboardDidShowNotification, selector: #selector(keyboardDidShow))
        subscribeToNotification(UIKeyboardDidHideNotification, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromAllNotifications()
    }

    
}

// MARK: - KeyboardViewController: UITextFieldDelegate

extension KeyboardViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configureTextFields(textFields: [UITextField], viewOnKeyboard : UIView?, distToKeyBoard : CGFloat) {
        self.textFields = textFields
        self.viewOnKeyboard = viewOnKeyboard
        self.distToKeyBoard = distToKeyBoard
        
        for textField in textFields {
            textField.delegate = self
            addToolBar(textField)
        }
        
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y = -movingHeight(notification)
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
    
    private func movingHeight(notification: NSNotification) -> CGFloat {
        
        var height : CGFloat = 0
        
        // keyboard Height
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight =  keyboardSize.CGRectValue().height
        
        // get textFiled
        var view : UIView?
        if let botView = viewOnKeyboard {
            view = botView
        } else {

            for textField in textFields {
                if textField.isFirstResponder() {
                    view = textField
                    break
                }
            }
        }
        
        // get textField height
        if let botView = view {
            
            // get textField height
            let lx = botView.frame.width
            let ly = botView.frame.height
            let p = CGPoint(x: lx, y: ly)
            let pos = botView.convertPoint(p, toView: nil)
            let textHeight = pos.y + distToKeyBoard
            
            // total height
            let H = self.view.frame.height
            
            // if keyboard won't cover text
            if H - textHeight > keyboardHeight {
                height = 0
            } else {
                height = keyboardHeight + textHeight - H
            }
        }
        
        return height
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
    func resignAll() {
        for textField in textFields {
            resignIfFirstResponder(textField)
        }
    }
    
    private func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        //toolBar.tintColor = UIColor(red: 76./255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(KeyboardViewController.resignAll))
        //let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(KeyboardViewController.resignAll))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
}

// MARK: - KeyboardViewController (Notifications)
extension KeyboardViewController {
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
