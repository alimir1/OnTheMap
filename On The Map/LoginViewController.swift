//
//  ViewController.swift
//  On The Map
//
//  Created by Ali Mir on 10/22/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFild: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let activityView = UIActivityIndicatorView()
    

    // MARK: Actions
    
    @IBAction func loginPressed(sender: AnyObject) {
        if emailTextField.text!.isEmpty || passwordTextFild.text!.isEmpty {
            // do something here
        } else {
            self.setUIEnabled(enabled: false)
            
            // start animating activity indicator
            ActivityIndicatorView.startAnimatingActivityIndicator(activityView: activityView, controller: self, style: .whiteLarge)
            
            UdacityClient.sharedInstance().postUdacitySession(username: emailTextField!.text!, password: passwordTextFild!.text!) {
                (successfullyPostedUdacitySession, error) in
                if successfullyPostedUdacitySession {
                    UdacityClient.sharedInstance().getUdacityPublicUserData() {
                        (success, error) in
                        performUIUpdatesOnMain {
                            if success == true {
                                self.completeLogin()
                            } else {
                                print("loginViewController: Could not get UdacityUser!")
                            }
                        }
                    }
                } else {
                    print("Error in posting session: \(error)")
                    self.setUIEnabled(enabled: true)
                }
                // stop animating activity indicator
                ActivityIndicatorView.stopAnimatingActivityIndicator(activityView: self.activityView,controller: self)
            }
        }
    }
    
    // MARK: Login
    
    func completeLogin() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ManagerTabBarController") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }
    
}

// MARK: - LoginViewController (Configure UI)

extension LoginViewController {
    func setUIEnabled(enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextFild.isEnabled = enabled
        loginButton.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
}
