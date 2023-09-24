//
//  TableControllerVocal.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/22.
//

import UIKit
import Firebase
import FirebaseAuth

class TableControllerVocal: UITableViewController {
    let db = Firestore.firestore()
    private var firebaseDataArray = [FirebaseDataArray]()
    private let user = Auth.auth().currentUser
    var buttonName: String = ""
    var allEmailText = [String]()
    var selectCellEmail = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.rowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
        tableView.register (UINib (nibName:"Table0Cell", bundle: nil),forCellReuseIdentifier: "Table0Cell")
        downloadFromFirebase()
        tableView.reloadData()
        print("TableControllerVocal:\(buttonName)")
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "VocalToAdd", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VocalToAdd" {
            if let destinationVC = segue.destination as? AddViewController {
                destinationVC.buttonName = self.buttonName
            }
        }
    }
    @IBAction func logOutButton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut() // 登出当前用户
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true) // 导航回根部页面
            }
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
}

//MARK: -Firebase
extension TableControllerVocal {
    
    func downloadFromFirebase(){
        let collectionRef = db.collection("collection:\(buttonName)").order(by: "sendTime")// 替换为您的集合名称
        self.firebaseDataArray = []
        self.allEmailText = []
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error retrieving data from Firestore: \(error.localizedDescription)")
                print("download下载成功")
                return
            }
            if let documents = querySnapshot?.documents {
                for doc in documents {
                    if let name = doc.data()["Name"]as? String,
                       let location = doc.data()["Location"]as? String,
                       let musicStyle = doc.data()["MusicStyle"]as? String,
                       let selfIntroduction = doc.data()["SelfIntroduction"]as? String,
                       let someoneName = doc.data()["someoneName"]as? String
                    {
                        
                        let balabala = FirebaseDataArray(name: name,
                                                         musicStyle: musicStyle,
                                                         location: location,
                                                         selfIntroduction: selfIntroduction)
                        self.firebaseDataArray.append(balabala)
                        self.allEmailText.append(someoneName)
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.firebaseDataArray.count - 1, section: 0)
                            self.tableView.scrollToRow(at:indexPath, at:.top, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func deleteFromFirebase(SelfIntroduction: String) {
            let collectionRef = db.collection("collection:\(buttonName)") // 替换为您的集合名称
            collectionRef.whereField("SelfIntroduction", isEqualTo: SelfIntroduction).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error querying Firestore: \(error.localizedDescription)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No documents found with the specified teamSelection")
                        return
                    }
                    // 删除匹配的文档（可能有多个匹配的文档）
                    for document in documents {
                        document.reference.delete { (error) in
                            if let error = error {
                                print("Error deleting document: \(error.localizedDescription)")
                            } else {
                                print("Document deleted successfully")
                            }
                        }
                    }
                }
            }
        
    }
    
    
    
}

//MARK: -TableView
extension TableControllerVocal {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.firebaseDataArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Table0Cell",for: indexPath) as! Table0Cell
        cell.nameText.text = "Name:  \(firebaseDataArray[indexPath.row].name)"
        cell.locationText.text = "Location:  \(firebaseDataArray[indexPath.row].location)"
        cell.musicStyleText.text = "Music Style:  \(firebaseDataArray[indexPath.row].musicStyle)"
        cell.selfIntroductionText.text = "Self Introduction:  \n  \(firebaseDataArray[indexPath.row].selfIntroduction)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //selectCellEmail = indexPath.row
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        selectCellEmail = 0
        let point = gestureRecognizer.location(in: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: point) {
            selectCellEmail = indexPath.row
            if gestureRecognizer.state == .began {
                let collectionRef = db.collection("collection:\(buttonName)")
                collectionRef.getDocuments { (querySnapshot, error) in
                    if let documents = querySnapshot?.documents{
                        for doc in documents{
                            if let selfIntroduction = doc.data()["SelfIntroduction"]as? String{
                             //  ,let someoneName = doc.data()["someoneName"]as? String
                                if self.user!.email == self.allEmailText[self.selectCellEmail]{
                                        let alertController = UIAlertController(title: "Delete Item",message: "Are you sure you want to delete this item?",preferredStyle: .alert)
                                        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                                            let ToDelete = selfIntroduction
                                            self.deleteFromFirebase(SelfIntroduction: ToDelete)
                                            self.firebaseDataArray.remove(at: indexPath.row)
                                            print(ToDelete)
                                            self.tableView.reloadData()
                                        }
                                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                        
                                        alertController.addAction(deleteAction)
                                        alertController.addAction(cancelAction)
                                        
                                        self.present(alertController, animated: true, completion: nil)
                                    
                                }
                                
                                
                                else{
                                    let alertController = UIAlertController(title: "What?!", message: "You want to delete others message?", preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                    alertController.addAction(cancelAction)
                                    self.present(alertController,animated: true,completion: nil)
                                }
                            }
                        }
                    }
                }
                
                
            }
        }//if let indexPath = self.tableView.indexPathForRow(at: point)
    }
}

