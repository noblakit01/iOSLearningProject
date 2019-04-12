//
//  LoginController.swift
//  SaitamaBicycle
//
//  Created by luan on 7/16/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    // MARK: Variables
    private var showingLoginView: Bool = true
    private var waitingActivityIndicator: UIActivityIndicatorView? = nil
    
    // MARK: Outlet
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var loginView: UIStackView!
    @IBOutlet weak var signUpStackView: UIStackView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var showLoginButton: UIButton!
    
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
  
    // MARK: Override View Controller function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = KeychainWrapper.stringForKey(accessTokenKeychain) {
            goToMap()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        signUpStackView.hidden = true
        showLoginButton.hidden = true
    }
    
    // MARK: Action
    
    @IBAction func signUpPressed(sender: AnyObject) {
        if showingLoginView {
            loginButton.hidden = true
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(), animations: {
                self.loginView.hidden = true
                self.signUpStackView.hidden = false
                self.showLoginButton.hidden = false
                }, completion: { (_) in
                    self.showingLoginView = false
            })
        } else {
            ServerHelper.sharedInstance.doRegister(registerEmailTextField.text!, password: registerPasswordTextField.text!, completition: { success in
                if success {
                    self.goToMap()
                }
            })
        }
    }
    
    @IBAction func showLoginPressed(sender: AnyObject) {
        if !showingLoginView {
            loginButton.hidden = false
            showLoginButton.hidden = true
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(), animations: {
                self.loginView.hidden = false
                self.signUpStackView.hidden = true
                }, completion: { (_) in
                    self.showingLoginView = true
            })
        }
    }
    
    private func goToMap() {
        performSegueWithIdentifier("ShowMap", sender: nil)
    }
}


// MARK: Login work
extension LoginController {
    @IBAction func loginPressed(sender: AnyObject) {
        ServerHelper.sharedInstance.doLogin(loginEmailTextField.text!, password: registerPasswordTextField.text!)
        
        waitingActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        waitingActivityIndicator!.center = view.center
        waitingActivityIndicator!.startAnimating()
        view.addSubview(waitingActivityIndicator!)
    }
}
