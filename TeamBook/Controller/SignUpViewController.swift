//
//  SignUpViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/15.
//

import UIKit
import Firebase
import FirebaseAuth

class SingUpViewController: UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            if let _ = error {
                let alertController = UIAlertController(title: "Something Wrong !", message: "1.Please enter your right email.\n2.The password must be 6 string long or more.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController,animated: true,completion: nil)
            } else {
                self.performSegue(withIdentifier: "SignUpToLogIn", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpToLogIn" {
            if let destinationVC = segue.destination as? LogInController {
                if let email = emailTextField.text, let password = passwordTextField.text{
                    destinationVC.logInEmailText = email
                    destinationVC.logInPasswordText = password
                }
            }
        }
    }
    
}
