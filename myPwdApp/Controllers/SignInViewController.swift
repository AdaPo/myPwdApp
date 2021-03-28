//
//  SignInViewController.swift
//  myPwdApp
//
//  Created by Adam Poustka on 2021-03-27.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // Signing up user with existing account
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        
        // Checking for nil in textfields
        if let email = emailTextField.text, let password = pwdTextField.text {
            // Firebase authentication
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // Performing segue to Home screen
                    self.performSegue(withIdentifier: "SignInToHome", sender: self)
                }
            }
            
        
        }
    }
}
