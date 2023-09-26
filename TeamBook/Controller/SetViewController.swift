//
//  SetViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/26.
//

import UIKit
import FirebaseAuth

class SetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func LogOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut() // 登出当前用户
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        } catch { print("Error signing out") }
    }
    
}
