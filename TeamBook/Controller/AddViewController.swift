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
    let db = Firestore.firestore()
    var buttonName: String = ""
    private var firebaseDataArray = [FirebaseDataArray]()
    private let user = Auth.auth().currentUser
    
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var MusicStyleText: UITextField!
    @IBOutlet weak var SelfIntroductionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddController:\(buttonName)")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func sendToFirebase(){
        let collectionRef = db.collection("collection:\(buttonName)") // 替换为您的集合名称
        collectionRef.addDocument(data: ["Name":self.NameText!.text!,
                                         "Location":self.LocationText!.text!,
                                         "MusicStyle":self.MusicStyleText!.text!,
                                         "SelfIntroduction":self.SelfIntroductionText!.text!,
                                         "sendTime":Date().timeIntervalSince1970,
                                         "someoneName":String(user!.email!)
                                        ]) { (error) in
            if let error = error {
                print("Error saving data to Firestore: \(error.localizedDescription)")
            } else {
                print("Data saved to Firestore successfully")
            }
        }
    }
    
    @IBAction func AddAllTextButton(_ sender: UIButton) {
        sendToFirebase()
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
