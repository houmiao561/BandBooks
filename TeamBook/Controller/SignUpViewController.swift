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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 隐藏键盘
        return true
    }
    
    // 点击键盘以外的区域时调用
    @objc func dismissKeyboard() {
        view.endEditing(true) // 隐藏键盘
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        performSegue(withIdentifier: "SignUpToLogIn", sender: self)
    }
    
    
}
