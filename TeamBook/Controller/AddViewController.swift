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
    
    
    var onDataReceived: ((FirebaseDataArray) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 在 B 中的某个地方触发闭包，比如在用户完成某个任务时
        
    }
    
    func taskCompleted() {
        var array = FirebaseDataArray(name: NameText.text ?? "",
                                      musicStyle: MusicStyleText.text ?? "",
                                      location: LocationText.text ?? "",
                                      selfIntroduction: SelfIntroductionText.text ?? "",
                                      allEmailText:"\(String(describing: self.user!.email))")
        onDataReceived!(array)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func sendToFirebase(){
        let collectionRef = db.collection("collection:\(buttonName)") // 替换为您的集合名称
        collectionRef.addDocument(data: ["Name":self.NameText!.text!,
                                         "Location":self.LocationText!.text!,
                                         "MusicStyle":self.MusicStyleText!.text!,
                                         "SelfIntroduction":self.SelfIntroductionText!.text!,
                                         "sendTime":Date().timeIntervalSince1970,
                                         "someoneName":String(user!.email!)] ) { _ in
            self.taskCompleted()
        }
    }
    
    @IBAction func AddAllTextButton(_ sender: UIButton) {
        sendToFirebase()
        self.navigationController?.popViewController(animated: true)
    }
    
}
