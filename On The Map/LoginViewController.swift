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
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    
    @IBAction func loginPressed(sender: AnyObject) {
        if emailTextField.text!.isEmpty || passwordTextFild.text!.isEmpty {
            // do something here
        } else {
            self.setUIEnabled(enabled: false)
            
            // start animating activity indicator
            activityView.center = self.view.center
            activityView.startAnimating()
            self.view.addSubview(activityView)
            
            UdacityClient.sharedInstance().postUdacitySession(username: emailTextField!.text!, password: passwordTextFild!.text!) {
                (successfullyPostedUdacitySession, error) in
                if successfullyPostedUdacitySession {
                    UdacityClient.sharedInstance().getUdacityPublicUserData() {
                        (success, error) in
                        if success == true {
                            self.completeLogin()
                            
                            // stop animating activity indicator
                            self.view.addSubview(self.activityView)
                            self.activityView.stopAnimating()
                            self.activityView.removeFromSuperview()
                        } else {
                            print("loginViewController: Could not get UdacityUser!")
                        }
                    }
                } else {
                    print("Error in posting session: \(error)")
                    
                    self.setUIEnabled(enabled: true)
                    
                    // stop animating activity indicator
                    self.view.addSubview(self.activityView)
                    self.activityView.stopAnimating()
                    self.activityView.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: Login
    
    func completeLogin() {
        performUIUpdatesOnMain {
            ParseClient.sharedInstance().getMultipleStudentLocations() {
                (result, error) in
                print("started...")
            }
            self.setUIEnabled(enabled: true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
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
