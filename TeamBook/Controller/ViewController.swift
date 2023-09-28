//
//  ViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/15.
//

import UIKit


class ViewController: UIViewController {

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
        performSegue(withIdentifier: "WelcomeToMain0", sender: self)
    }
}

