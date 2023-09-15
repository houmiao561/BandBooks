//
//  SignUpViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/15.
//

import UIKit
import Realm
import Firebase
class SingUpViewController: UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        if let emialText = emailTextField.text, let passwordText = passwordTextField.text{
            Auth.auth().createUser(withEmail: emialText, password: passwordText){ _ ,error in
                if let e = error{print("123")}
                else{
                    print("321")
                }
            }
        }
        performSegue(withIdentifier: "SignUpToLogIn", sender: self)
    }
    
    
}
