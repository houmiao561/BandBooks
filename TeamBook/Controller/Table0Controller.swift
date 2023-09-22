//
//  TableController0.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/19.
//

import UIKit
import Firebase
import FirebaseAuth

struct FirebaseDataArray{
    var nameFromStruct: String
    var commentTextFromStruct: String
}
class Table0Controller: UITableViewController {
    let db = Firestore.firestore()
    var firebaseDataArray = [FirebaseDataArray]()
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
        tableView.register (UINib (nibName:"Table0Cell", bundle: nil),forCellReuseIdentifier: "Table0Cell")
        downloadFromFirebase()
        tableView.reloadData()
    }
    
    @IBAction func addButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Text", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in textField.placeholder = "Enter text" }
        
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let text = alertController.textFields?.first?.text {
                    self.sendToFirebase(with: text)
                    DispatchQueue.main.async {
                        self.downloadFromFirebase()
                        self.tableView.reloadData()
                    }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        // 弹出 UIAlertController
        present(alertController, animated: true, completion: nil)
        downloadFromFirebase()
        tableView.reloadData()
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
extension Table0Controller {
    func sendToFirebase(with whichTeam: String){
        if let name = self.user?.email{
            let collectionRef = db.collection("collectionName:\(name)") // 替换为您的集合名称
            collectionRef.addDocument(data: ["teamSelection":whichTeam,"time":Date().timeIntervalSince1970,"someoneName":String(user!.email!)]) { (error) in
                if let error = error {
                    print("Error saving data to Firestore: \(error.localizedDescription)")
                } else {
                    print("Data saved to Firestore successfully")
                }
            }
        }
    }
    
    func downloadFromFirebase(){
        if let name = self.user?.email{
            let collectionRef = db.collection("collectionName:\(name)").order(by: "time")// 替换为您的集合名称
            self.firebaseDataArray = []
            collectionRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error retrieving data from Firestore: \(error.localizedDescription)")
                    print("download下载成功")
                    return
                }
                if let documents = querySnapshot?.documents {
                    for doc in documents {
    

                        if let teamSelection = doc.data()["teamSelection"]as? String, let someoneName = doc.data()["someoneName"]as? String{
                            let balabala: FirebaseDataArray = FirebaseDataArray(nameFromStruct: someoneName, commentTextFromStruct: teamSelection)
                            self.firebaseDataArray.append(balabala)
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
    }

    func deleteFromFirebase(teamSelection: String) {
        if let name = self.user?.email{
            let collectionRef = db.collection("collectionName:\(name)") // 替换为您的集合名称
            
            // 查询包含指定 "teamSelection" 值的文档
            collectionRef.whereField("teamSelection", isEqualTo: teamSelection).getDocuments { (querySnapshot, error) in
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
}

//MARK: -TableView
extension Table0Controller {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseDataArray.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Table0Cell",for: indexPath) as! Table0Cell
        cell.commentText.text = firebaseDataArray[indexPath.row].commentTextFromStruct
        cell.name.text = String(self.user!.email!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            // 获取长按点所在的IndexPath
            let point = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                let alertController = UIAlertController(title: "Delete Item",message: "Are you sure you want to delete this item?",preferredStyle: .alert)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                    let teamSelectionToDelete = self.firebaseDataArray[indexPath.row]
                    self.deleteFromFirebase(teamSelection: self.firebaseDataArray[indexPath.row].commentTextFromStruct)
                    self.firebaseDataArray.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }
}
