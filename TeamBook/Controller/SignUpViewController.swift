//
//  SignUpViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/15.
//

import UIKit
import Firebase
import FirebaseAuth
import NVActivityIndicatorView

class SingUpViewController: UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var activityIndicatorView: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 注册加载动画
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
    }
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        activityIndicatorView.startAnimating()
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            if let _ = error {
                let alertController = UIAlertController(title: "Something Wrong !", message: "1.Please enter your right email.\n2.The password must be 6 string long or more.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.activityIndicatorView.stopAnimating()
                self.present(alertController,animated: true,completion: nil)
            } else {
                self.activityIndicatorView.stopAnimating()
                let alertController = UIAlertController(title: "Great!", message: "Sign Up and Log In Succeed.", preferredStyle: .alert)
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
