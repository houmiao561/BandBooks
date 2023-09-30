//
//  SetViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/26.
//

import UIKit
import FirebaseAuth

class SetViewController: UIViewController {

    @IBOutlet weak var LogOutButtonIB: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    private let user = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        if user == nil{
            emailLabel.text = "No Account Email Log In\nPlz Sign Up and Log In"
            LogOutButtonIB.titleLabel?.text = "Back to Main Page\nLog In"
            LogOutButtonIB.titleLabel?.textAlignment = .center
            LogOutButtonIB.titleLabel?.numberOfLines = 2
        }else if user != nil{
            emailLabel.text = user!.email
            LogOutButtonIB.titleLabel?.text = "Log Out"
            LogOutButtonIB.titleLabel?.textAlignment = .center
            LogOutButtonIB.titleLabel?.numberOfLines = 1
        }
        
    }
    
    @IBAction func LogOutButton(_ sender: Any) {
        do {
            if let navigationController = self.navigationController {
                            navigationController.popToRootViewController(animated: true)
            try Auth.auth().signOut() // 登出当前用户
            }
        } catch { print("Error signing out") }
    }
    
    @IBAction func DeveloperLogButton(_ sender: Any) {
        performSegue(withIdentifier: "SetToDeveloperLog", sender: sender)
    }
}
