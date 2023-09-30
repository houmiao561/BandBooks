//
//  ViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/15.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    private let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil{
            performSegue(withIdentifier: "WelcomeToMain0", sender: self)
        }
    }

    @IBAction func signUpButton(_ sender: UIButton) {
        performSegue(withIdentifier: "WelcomeToSignUp", sender: self)
    }
    @IBAction func logInButton(_ sender: UIButton) {
        performSegue(withIdentifier: "WelcomeToLogIn", sender: self)
    }
    
    @IBAction func GuestModeButton(_ sender: UIButton) {
        performSegue(withIdentifier: "WelcomeToMain0", sender: self)
    }
    
}

