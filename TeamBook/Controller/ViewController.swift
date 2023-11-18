//
//  ViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/15.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class ViewController: UIViewController {
    private let user = Auth.auth().currentUser
    var activityIndicatorView: NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signUpButton(_ sender: UIButton) {
        performSegue(withIdentifier: "WelcomeToSignUp", sender: self)
    }
    @IBAction func logInButton(_ sender: UIButton) {
        performSegue(withIdentifier: "WelcomeToLogIn", sender: self)
    }
    
    @IBAction func GuestModeButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func account(_ sender: UIButton) {
        performSegue(withIdentifier: "ViewToSet", sender: sender)
    }
}

