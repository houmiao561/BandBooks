//
//  TableControllerGuitar.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/22.
//
import UIKit
import Firebase
import FirebaseAuth

class TableControllerGuitar: UITableViewController {
    let db = Firestore.firestore()
    private var firebaseDataArray = [FirebaseDataArray]()
    private let user = Auth.auth().currentUser
    var buttonName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
        tableView.register (UINib (nibName:"Table0Cell", bundle: nil),forCellReuseIdentifier: "Table0Cell")
        downloadFromFirebase()
        tableView.reloadData()
    }
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "GuitarToAdd", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GuitarToAdd" {
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
extension TableControllerGuitar{
    
    func downloadFromFirebase(){
        let collectionRef = db.collection("collection:\(buttonName)").order(by: "sendTime")// 替换为您的集合名称
        self.firebaseDataArray = []
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
                       let selfIntroduction = doc.data()["SelfIntroduction"]as? String
                    {
                        let balabala = FirebaseDataArray(name: name,
                                                         musicStyle: musicStyle,
                                                         location: location,
                                                         selfIntroduction: selfIntroduction)
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
    
    func deleteFromFirebase(Name: String) {
        let collectionRef = db.collection("collectionNameGuitar") // 替换为您的集合名称
        
        // 查询包含指定 "teamSelection" 值的文档
        collectionRef.whereField("Name", isEqualTo: Name).getDocuments { (querySnapshot, error) in
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
extension TableControllerGuitar {
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
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            // 获取长按点所在的IndexPath
            let point = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                let alertController = UIAlertController(title: "Delete Item",message: "Are you sure you want to delete this item?",preferredStyle: .alert)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                    let NameToDelete = self.firebaseDataArray[indexPath.row].name
                    self.deleteFromFirebase(Name: NameToDelete)
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

