//
//  AddViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/22.
//

import UIKit
import Firebase
import FirebaseAuth


class AddViewController: UIViewController {
    var buttonName: String = ""
    private var firebaseDataArray = [FirebaseDataArray]()
    private let user = Auth.auth().currentUser
    
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var MusicStyleText: UITextField!
    @IBOutlet weak var SelfIntroductionText: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        let swipeDownGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        view.addGestureRecognizer(swipeDownGesture)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            SelfIntroductionText.contentInset = .zero
        } else {
            SelfIntroductionText.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom+15, right: 0)
        }
        SelfIntroductionText.scrollIndicatorInsets = SelfIntroductionText.contentInset
        let selectedRange = SelfIntroductionText.selectedRange
        SelfIntroductionText.scrollRangeToVisible(selectedRange)
    }
    func sendToFirebase(){
        let collectionRef = db.collection("collection:\(buttonName)") // 替换为您的集合名称
        collectionRef.addDocument(data: ["Name":self.NameText!.text!,
                                         "Location":self.LocationText!.text!,
                                         "MusicStyle":self.MusicStyleText!.text!,
                                         "SelfIntroduction":self.SelfIntroductionText!.text!,
                                         "sendTime":Date().timeIntervalSince1970,
                                         "someoneName":String(user!.email!)] ) { _ in }
    }
    
    @IBAction func AddAllTextButton(_ sender: UIButton) {
        if user != nil{
            sendToFirebase()
            self.navigationController?.popViewController(animated: true)
        }else{
            let alertController = UIAlertController(title: "Please Log In!",message: "If U want to send message\nPlz sign up and log in",preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
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
