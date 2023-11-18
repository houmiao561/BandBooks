//
//  LogInViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/15.
//

import UIKit
import Firebase
import FirebaseAuth
import NVActivityIndicatorView

class LogInController: UIViewController{
    @IBOutlet weak var LogInEmailTextField: UITextField!
    @IBOutlet weak var LogInPasswordTextField: UITextField!
    var logInEmailText = ""
    var logInPasswordText = ""
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogInEmailTextField.text = logInEmailText
        LogInPasswordTextField.text = logInPasswordText
        
        // 注册加载动画
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        activityIndicatorView.startAnimating()
        Auth.auth().signIn(withEmail: LogInEmailTextField.text!, password: LogInPasswordTextField.text!) { (authResult, error) in
            if let _ = error {
                self.activityIndicatorView.stopAnimating()
                let alertController = UIAlertController(title: "Something Wrong !", message: "Please check your email and password.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController,animated: true,completion: nil)
            } else {
                self.activityIndicatorView.stopAnimating()
                let alertController = UIAlertController(title: "Great!", message: "Log In Succeed.", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                
                // 延时两秒后自动关闭 UIAlertController
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    alertController.dismiss(animated: true, completion: nil)
                    self.navigationController!.popToRootViewController(animated: true)
                }
            }
        }
    }
}
