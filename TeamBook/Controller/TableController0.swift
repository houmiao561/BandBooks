//
//  TableController0.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/19.
//

import UIKit
import RealmSwift
import Firebase

class TableController0: UITableViewController {
    
    let realm = try! Realm()
    var teams : Results<Team>?
    let db = Firestore.firestore()
    var FirebaseDataArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        teams = realm.objects(Team.self)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
        downloadFromFirebase()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseDataArray.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        cell.textLabel?.text = FirebaseDataArray[indexPath.row]
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
                    let teamSelectionToDelete = self.FirebaseDataArray[indexPath.row]
                    self.deleteFromFirebase(teamSelection: teamSelectionToDelete)
                    self.deleteItemFromRealm(at: indexPath)
                    self.FirebaseDataArray.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
                
            }
        }
    }

    func deleteItemFromRealm(at indexPath: IndexPath) {
        // 获取要删除的对象，假设您的数据源是 Realm 中的 Results<Item>
        if let teamToDelete = teams?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(teamToDelete)
                }
                teams = realm.objects(Team.self)
            } catch {
                print("Error deleting item from Realm: \(error.localizedDescription)")
            }
        }
    }
    func deleteFromFirebase(teamSelection: String) {
        let collectionRef = db.collection("collectionName") // 替换为您的集合名称
        
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

    func sendToFirebase(with whichTeam: String){
        let collectionRef = db.collection("collectionName") // 替换为您的集合名称
        collectionRef.addDocument(data: ["teamSelection":whichTeam,"time":Date().timeIntervalSince1970]) { (error) in
               if let error = error {
                   print("Error saving data to Firestore: \(error.localizedDescription)")
               } else {
                   print("Data saved to Firestore successfully")
               }
           }
    }
    
    func downloadFromFirebase(){
        let collectionRef = db.collection("collectionName").order(by: "time")// 替换为您的集合名称
        self.FirebaseDataArray = []
        collectionRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error retrieving data from Firestore: \(error.localizedDescription)")
                    return
                }
                // 处理查询结果并将数据存储到 dataArray 中
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        if let data = doc.data()["teamSelection"] as? String {
                            self.FirebaseDataArray.append(data)
                            DispatchQueue.main.async{
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.FirebaseDataArray.count - 1, section: 0)
                                self.tableView.scrollToRow(at:indexPath, at:.top, animated: true)
                            }
                        }
                    }
                }
            }
    }

    
    @IBAction func addButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Text", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in textField.placeholder = "Enter text" }

        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let text = alertController.textFields?.first?.text {
                do {
                    try self.realm.write {
                        let newTeam = Team()
                        newTeam.whichTeamRealm = text
                        self.realm.add(newTeam)
                    }
                    self.sendToFirebase(with: text)
                    self.teams = self.realm.objects(Team.self)
                    DispatchQueue.main.async {
                        self.downloadFromFirebase()
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error saving data to Realm: \(error.localizedDescription)")
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
        if let realmURL = Realm.Configuration.defaultConfiguration.fileURL {
            print("Realm file location: \(realmURL)")
        }
    }

}

