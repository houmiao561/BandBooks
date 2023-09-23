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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        let swipeDownGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        view.addGestureRecognizer(swipeDownGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
                performSegue(withIdentifier: "LogInToMain0", sender: self)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // 处理下滑手势
    @objc func handleSwipeDown(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let velocity = gestureRecognizer.velocity(in: view)
            if velocity.y > 0 { // 用户向下滑动
                view.endEditing(true) // 隐藏键盘
            }
        }
    }
}
