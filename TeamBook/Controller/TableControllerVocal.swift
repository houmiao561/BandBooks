//
//  TableControllerVocal.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/22.
//

import UIKit
import Firebase
import FirebaseAuth

class TableControllerVocal: UITableViewController,UIGestureRecognizerDelegate {
    private var firebaseDataArray = [FirebaseDataArray]()
    var swipeGestureRecognizer: UISwipeGestureRecognizer!
    var tapGestureRecognizer: UITapGestureRecognizer!


    @IBOutlet weak var searchBar: UISearchBar!
    private let user = Auth.auth().currentUser
    private var selectCellEmail = 0
    lazy var buttonName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.rowHeight = 80
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)

        // 创建一个向下滑动手势识别器
            swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            swipeGestureRecognizer.direction = .down
            swipeGestureRecognizer.delegate = self

            // 添加手势识别器到UITableView
            tableView.addGestureRecognizer(swipeGestureRecognizer)
        
        // 创建一个向下滑动手势识别器
            swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGestureRecognizer.direction = .up
            swipeGestureRecognizer.delegate = self
        

            // 添加手势识别器到UITableView
            tableView.addGestureRecognizer(swipeGestureRecognizer)
        
        // 创建一个点击手势识别器
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
            tapGestureRecognizer.delegate = self

            // 添加手势识别器到UITableView
            tableView.addGestureRecognizer(tapGestureRecognizer)
        
        
        
        tableView.register (UINib (nibName:"Table0Cell", bundle: nil),forCellReuseIdentifier: "Table0Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        downloadFromFirebase()
        tableView.reloadData()
        title = buttonName
    }
    
    @objc func handleSwipeGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        // 检查手势方向是否为向下滑动
        if gestureRecognizer.direction == .down{
            // 收起搜索栏的键盘
            searchBar.resignFirstResponder()

            // 执行其他你想要的滑动操作
            // 比如滚动UITableView或其他一些操作
        }
        if gestureRecognizer.direction == .up{
            // 收起搜索栏的键盘
            searchBar.resignFirstResponder()

            // 执行其他你想要的滑动操作
            // 比如滚动UITableView或其他一些操作
        }
    }
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        // 检查手势的状态是否为ended，以确保只在点击结束时触发操作
        if gestureRecognizer.state == .ended {
            let location = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: location) {
                searchBar.resignFirstResponder()
                selectCellEmail = 0
                selectCellEmail = indexPath.row
                tableView.deselectRow(at: indexPath, animated: true)
                performSegue(withIdentifier: "VocalToDetail", sender: self)
            } else {
                // 用户点击了UITableView但未点击到任何单元格
                // 这里你可以执行收起搜索栏键盘的操作
                searchBar.resignFirstResponder()
            }
        }
    }

    //与其他手势协同工作
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func AddButton(_ sender: UIButton) {
        performSegue(withIdentifier: "VocalToAdd", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VocalToAdd" {
            if let destinationVC = segue.destination as? AddViewController {
                destinationVC.buttonName = self.buttonName
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

//MARK: -Firebase
extension TableControllerVocal {
    
    func downloadFromFirebase(){
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
                            //let indexPath = IndexPath(row: self.firebaseDataArray.count - 1, section: 0)
                        }
                    }
                }
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
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectCellEmail = 0
//        selectCellEmail = indexPath.row
//        tableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: "VocalToDetail", sender: self)
//    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if user != nil {
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
                                    if self.user!.email == self.firebaseDataArray[self.selectCellEmail].allEmailText{
                                        let alertController = UIAlertController(title: "Delete Item",message: "Are you sure you want to delete this item?",preferredStyle: .alert)
                                        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
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
            }
        }else{
            let alertController = UIAlertController(title: "Please Log In!",message: "If U want to send message\nPlz sign up and log in",preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
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

