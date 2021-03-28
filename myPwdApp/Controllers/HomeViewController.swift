//
//  HomeViewController.swift
//  myPwdApp
//
//  Created by Adam Poustka on 2021-03-28.
//

import UIKit
import Firebase
import CryptoKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var passwordTableView: UITableView!
    
    // Initializing firestore db and cryptomanager
    let db = Firestore.firestore()
    let cm = CryptoManager()
    
    // Empty array of Password items
    var passwords: [Password] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        // Setting datasource for tableview
        passwordTableView.dataSource = self
    
        passwordTableView.rowHeight = 80
        
        // Registering xib PasswordCell with "PasswordCell" identifier
        passwordTableView.register(UINib(nibName: "PasswordCell", bundle: nil), forCellReuseIdentifier: "PasswordCell")
    }
    
    // Loading data from firebase database
    func loadData() {
        
        db.collection("passwords").addSnapshotListener { (querySnapshot, error) in
            self.passwords = []
            // Checking for error
            if let e = error {
                print("Error loading data from Firestore: \(e)")
            } else {
                
                if let snapshotDocuments = querySnapshot?.documents {
                    // Iterating over documents from query
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        // checking for nil
                        if let title = data["title"] as? String, let pwd = data["password"] as? Data {
                            // Creating newPassword with data obtained from firestore db
                            let newPassword = Password.init(title: title, pwd: pwd)
                            // Appending new item to array of passwords
                            self.passwords.append(newPassword)
                            // Reloading tableview so the passwords show on screen
                            DispatchQueue.main.async {
                                self.passwordTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // User is logged out on button press
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            // Jumping back to welcome screen
            navigationController?.popToRootViewController(animated: false)
        } catch let signOutError as NSError {
            print("Error logging out: ", signOutError)
        }
    }
    
    // Adding new password
    @IBAction func addButtonPressed(_ sender: Any) {
        //        let data = Data()
        //        var securedBox = try! ChaChaPoly.SealedBox(combined: data)
        
        var titleTextField = UITextField()
        var pwdTextField = UITextField()
        
        //  Creating and presenting alert, in which I add new password to store
        let alert = UIAlertController(title: "Add password", message: "", preferredStyle: .alert)
        // Creating action for alert
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // let securedBox = self.cm.encrypt(password: pwdTextField.text!)
            
            // Checking for nil in textfields and for user
            if let title = titleTextField.text,
               let pwd = pwdTextField.text,
               let currentUser = Auth.auth().currentUser?.email  {
                // encrypting string from passwordTextField
                let securedBoxData = self.cm.encrypt(password: pwd)
                // Appending Password object to array of passwords
                self.passwords.append(Password(title: title,
                                               pwd: securedBoxData))
                
                // Adding data to firestore
                self.db.collection("passwords").addDocument(data: [
                    "current_user":currentUser,
                    "title": title,
                    "password": securedBoxData
                ]) { (error) in
                    if let e = error {
                        print("There was an error saving data to Firebase: \(e)")
                    } else {
                        print("Succesfully saved data to firebase")
                    }
                }
                // Reloading data in Tableview
                DispatchQueue.main.async {
                
                    self.passwordTableView.reloadData()
                }
               
            }
        }
        
        // Adding textifelds to alert
        alert.addTextField { (alertTitleTextField) in
            alertTitleTextField.placeholder = "Add password for"
            titleTextField = alertTitleTextField
        }
        alert.addTextField { (alertPwdTextField) in
            alertPwdTextField.placeholder = "Add password"
            pwdTextField = alertPwdTextField
        }
        
        // Adding action to alert
        alert.addAction(action)
        
        // Presenting alert
        present(alert, animated: true, completion: nil)
        
    }
    
}



//MARK: - TableView Datasource methods

extension HomeViewController: UITableViewDataSource {
    
    // This datasource method returns the number of rows in section, that is given by the amount of Password objects in passwords array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwords.count
    }
    // Creating cell and presenting her in tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let wholePassword = passwords[indexPath.row]
        // Creating reusable cell with identifier as custom PasswordCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordCell", for: indexPath) as! PasswordCell
        
        cell.passwordTextLabel.isHidden = true
        cell.passwordTitleLabel.text = wholePassword.title
        cell.passwordTextLabel.text =  wholePassword.decryptedPassword
        
        return cell
    }
    
    
}
