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
    var logInEmailText = "114@hm.com"
    var logInPasswordText = "123456"
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        let swipeDownGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        view.addGestureRecognizer(swipeDownGesture)
        LogInEmailTextField.text = logInEmailText
        LogInPasswordTextField.text = logInPasswordText
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: LogInEmailTextField.text!, password: LogInPasswordTextField.text!)
        performSegue(withIdentifier: "LogInToMain0", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogInToMain0" {
            if let destinationVC = segue.destination as? Main0ViewController {
                destinationVC.backButtonHide = true
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
