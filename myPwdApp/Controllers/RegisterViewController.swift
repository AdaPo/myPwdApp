//
//  RegisterViewController.swift
//  myPwdApp
//
//  Created by Adam Poustka on 2021-03-27.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // Upon pressing register button new user is created and signed in
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        // Checking for nil in textfields
        if let email = emailTextField.text, let password = pwdTextField.text {
            // Firebase authentication method for creating new user
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // Moving to Home screen
                    self.performSegue(withIdentifier: "RegisterToHome", sender: self)
                }
            }
       
    }
    }

}
