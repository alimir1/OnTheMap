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
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    
    @IBAction func loginPressed(sender: AnyObject) {
        if emailTextField.text!.isEmpty || passwordTextFild.text!.isEmpty {
            // do something here
        } else {
            UdacityClient.sharedInstance().postUdacitySession(username: emailTextField.text!, password: passwordTextFild.text!) {
                (successfullyPostedUdacitySession, error) in
                if successfullyPostedUdacitySession {
                    self.completeLogin()
                } else {
                    self.setUIEnabled(enabled: true)
                    print("There was an error: \(error)")
                }
            }
        }
    }
    
    // MARK: Login
    
    func completeLogin() {
        performUIUpdatesOnMain {
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
