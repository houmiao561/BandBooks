//
//  SetViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/26.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class SetViewController: UIViewController {

    @IBOutlet weak var LogOutButtonIB: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    var user = Auth.auth().currentUser
    var activityIndicatorView: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 注册加载动画
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
        if user == nil{
            emailLabel.text = "No Account Email Log In\nPlease Sign Up and Log In"
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
        activityIndicatorView.startAnimating()
        do {
            if let navigationController = self.navigationController {
                if user == nil{
                    navigationController.popToRootViewController(animated: true)
                }else{
                    try Auth.auth().signOut() // 登出当前用户
                    self.activityIndicatorView.stopAnimating()
                    let alertController = UIAlertController(title: "Great!", message: "Log Out Succeed.", preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                    
                    // 延时两秒后自动关闭 UIAlertController
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        alertController.dismiss(animated: true, completion: nil)
                        navigationController.popToRootViewController(animated: true)
                    }
                }
            }
        } catch { print("Error signing out") }
    }
    
    @IBAction func DeveloperLogButton(_ sender: Any) {
        performSegue(withIdentifier: "SetToDeveloperLog", sender: sender)
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        if user == nil{
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            let alertController = UIAlertController(title: "Delete Account",message: "Are you sure you want to delete this Account?\nThis operation cannot be undone!!",preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.activityIndicatorView.startAnimating()
                do {
                    if let navigationController = self.navigationController {
                        try Auth.auth().signOut() // 登出当前用户
                        self.user?.delete { (error) in
                            if let error = error {
                                print("Error deleting user: \(error.localizedDescription)")
                                self.activityIndicatorView.stopAnimating()
                            } else {
                                self.activityIndicatorView.stopAnimating()
                                let alertController = UIAlertController(title: "Great!", message: "Delete Account Succeed.", preferredStyle: .alert)
                                self.present(alertController, animated: true, completion: nil)
                                
                                // 延时两秒后自动关闭 UIAlertController
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    alertController.dismiss(animated: true, completion: nil)
                                    navigationController.popToRootViewController(animated: true)
                                }
                            }
                        }
                    }
                } catch { print("Error signing out") }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
