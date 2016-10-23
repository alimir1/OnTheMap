//
//  ViewController.swift
//  On The Map
//
//  Created by Abidi on 10/22/16.
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
            setUIEnabled(enabled: true)
            
            var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error...
                    return
                }
                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
            }
            task.resume()
            
//            completeLogin()
            /*
                Do the login steps here something like this:
             
             TMDBClient.sharedInstance().authenticateWithViewController(self) { 
             (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        self.displayError(errorString)
                    }
                }
             }
             
             
            */
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
