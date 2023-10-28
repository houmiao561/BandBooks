//
//  LogInViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/15.
//

import UIKit
import Firebase
import FirebaseAuth

class LogInController: UIViewController{
    @IBOutlet weak var LogInEmailTextField: UITextField!
    @IBOutlet weak var LogInPasswordTextField: UITextField!
    var logInEmailText = ""
    var logInPasswordText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        LogInEmailTextField.text = logInEmailText
        LogInPasswordTextField.text = logInPasswordText
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: LogInEmailTextField.text!, password: LogInPasswordTextField.text!) { (authResult, error) in
            if let _ = error {
                let alertController = UIAlertController(title: "Something Wrong !", message: "Please check your email and password.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController,animated: true,completion: nil)
            } else {
                self.performSegue(withIdentifier: "LogInToMain0", sender: self)
            }
        }
    }
}
