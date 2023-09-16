//
//  LogInViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/15.
//

import UIKit
import Realm
import Firebase
import FirebaseAuth

class LogInController: UIViewController{
    @IBOutlet weak var LogInEmailTextField: UITextField!
    @IBOutlet weak var LogInPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: LogInEmailTextField.text!, password: LogInPasswordTextField.text!) { (user, error) in
            if let error = error {
                print("登录失败\(error)")
            } else if let user = user {
                print("登录成功，用户 ID：\(user.user.uid)")
            }
        }
        if let user = Auth.auth().currentUser{
            let email = user.email
            if email == "123@hm.com"{
                performSegue(withIdentifier: "LogInToMain", sender: self)
            }else{
                performSegue(withIdentifier: "LogInToMain1", sender: self)
            }
        }
        
    }
}
