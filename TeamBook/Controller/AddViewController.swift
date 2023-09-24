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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        let swipeDownGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        view.addGestureRecognizer(swipeDownGesture)
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
        sendToFirebase()
        self.navigationController?.popViewController(animated: true)
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
