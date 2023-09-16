//
//  SignUpViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/15.
//

import UIKit
import Realm
import Firebase
import FirebaseAuth

class SingUpViewController: UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        if let realEmialText = emailTextField.text, let realPasswordText = passwordTextField.text{
            Auth.auth().createUser(withEmail: realEmialText, password: realPasswordText){ _ ,error in
                if let e = error{print("123")}
                else{
                    print("321")
                }
            }
        }
        performSegue(withIdentifier: "SignUpToLogIn", sender: self)
    }
    
    
}
