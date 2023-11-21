//
//  TableControllerVocal.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/22.
//

import UIKit
import Firebase
import FirebaseAuth
import NVActivityIndicatorView

class TableControllerVocal: UITableViewController{
    
    private var firebaseDataArray = [FirebaseDataArray]()
    private let user = Auth.auth().currentUser
    private var selectCellEmail = 0
    lazy var buttonName: String = ""
    var activityIndicatorView: NVActivityIndicatorView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 注册加载动画
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
        
        
        downloadFromFirebase()
        tableView.reloadData()
        title = buttonName
        tableView.register (UINib (nibName:"Table0Cell", bundle: nil),forCellReuseIdentifier: "Table0Cell")
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeDownGestureRecognizer.direction = .down
        tableView.addGestureRecognizer(swipeDownGestureRecognizer)
        swipeDownGestureRecognizer.delegate = self
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeUpGestureRecognizer.direction = .up
        tableView.addGestureRecognizer(swipeUpGestureRecognizer)
        swipeUpGestureRecognizer.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tableView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    @IBAction func AddButton(_ sender: UIButton) {
        if user == nil{
            let alertController = UIAlertController(title: "Please Log In!",message: "If you want to send message\nPlease sign up and log in",preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            performSegue(withIdentifier: "VocalToAdd", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VocalToAdd" {
            if let destinationVC = segue.destination as? AddViewController {
                destinationVC.buttonName = self.buttonName
                destinationVC.onDataReceived = { data in
                    // 这里处理从 B 传递回来的数据
                    print("Data from B: \(data)")
                    self.firebaseDataArray.append(data as! FirebaseDataArray)
                    self.tableView.reloadData()
                    // 在闭包中执行 A 中的操作
                    // 例如，更新 UI 或执行其他逻辑
                }
            }
        }
        if segue.identifier == "VocalToDetail"{
            if let destinationVC = segue.destination as? DetailViewController{
                destinationVC.smallFirebase.name = self.firebaseDataArray[self.selectCellEmail].name
                destinationVC.smallFirebase.location = self.firebaseDataArray[self.selectCellEmail].location
                destinationVC.smallFirebase.musicStyle = self.firebaseDataArray[self.selectCellEmail].musicStyle
                destinationVC.smallFirebase.selfIntroduction = self.firebaseDataArray[self.selectCellEmail].selfIntroduction
            }
        }
    }
    
    
}
















//MARK: -gesture
extension TableControllerVocal: UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }//与其他手势协同工作
    
    @objc func handleSwipeGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.direction == .down{
            searchBar.resignFirstResponder()
        }
        if gestureRecognizer.direction == .up{
            searchBar.resignFirstResponder()
        }
    }
    
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let location = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: location) {
                searchBar.resignFirstResponder()
                selectCellEmail = 0
                selectCellEmail = indexPath.row
                tableView.deselectRow(at: indexPath, animated: true)
                performSegue(withIdentifier: "VocalToDetail", sender: self)
            } else {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        searchBar.resignFirstResponder()
        if user != nil {
            selectCellEmail = 0
            let point = gestureRecognizer.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: point) {
                selectCellEmail = indexPath.row
                if gestureRecognizer.state == .began {
                    var abc = self.firebaseDataArray
                    let selfIntroduction = abc[self.selectCellEmail].selfIntroduction
                    if self.user!.email == abc[self.selectCellEmail].allEmailText && selfIntroduction == abc[self.selectCellEmail].selfIntroduction{
                        let alertController = UIAlertController(title: "Delete Item",message: "Are you sure you want to delete this item?",preferredStyle: .alert)
                        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                            let ToDelete = selfIntroduction
                            self.deleteFromFirebase(SelfIntroduction: ToDelete)
                            self.firebaseDataArray.remove(at: indexPath.row)
                            self.tableView.reloadData()
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(deleteAction)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        let alertController = UIAlertController(title: "What?!", message: "You want to delete others message?", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController,animated: true,completion: nil)
                    }
                }
            }
        }else{
            let alertController = UIAlertController(title: "Please Log In!",message: "If you want to send message\nPlease sign up and log in",preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}

















//MARK: -Firebase
extension TableControllerVocal {
    
    func downloadFromFirebase(){
        self.activityIndicatorView.startAnimating()
        let collectionRef = db.collection("collection:\(buttonName)").order(by: "sendTime")// 替换为您的集合名称
        self.firebaseDataArray = []
        collectionRef.getDocuments { (querySnapshot,error)in
            
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
                                                         selfIntroduction: selfIntroduction,
                                                         allEmailText: someoneName)
                        self.firebaseDataArray.append(balabala)
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
                        }
                    }
                }
                self.activityIndicatorView.stopAnimating()
            }else{
                self.activityIndicatorView.stopAnimating()
            }
        }
        
    }
    
    func deleteFromFirebase(SelfIntroduction: String) {
        let collectionRef = db.collection("collection:\(buttonName)") // 替换为您的集合名称
        collectionRef.whereField("SelfIntroduction", isEqualTo: SelfIntroduction).getDocuments { (querySnapshot, error) in
            if let _ = error {
                print("Error querying Firestore")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents found with the specified teamSelection")
                    return
                }
                for doc in documents {
                    doc.reference.delete { _ in }
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
        cell.musicStyleText.text = "Style:  \(firebaseDataArray[indexPath.row].musicStyle)"
        
        return cell
    }
    
}

















//MARK: -SearchBar
extension TableControllerVocal: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0{
            downloadFromFirebase()
            tableView.reloadData()
        }else if searchBar.text != nil {
            let filteredItems = firebaseDataArray.filter { item in
                let containsName = item.name.lowercased().contains(searchText.lowercased())
                let containsLocation = item.location.lowercased().contains(searchText.lowercased())
                let containsMusicStyle = item.musicStyle.lowercased().contains(searchText.lowercased())
                return containsName || containsLocation || containsMusicStyle
            }
            firebaseDataArray = filteredItems
            tableView.reloadData()
        }
    }
    
    
}

