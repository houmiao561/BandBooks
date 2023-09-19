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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        teams = realm.objects(Team.self) // 假设 Item 是您的 Realm 数据库模型类
        tableView.reloadData()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams?.count ?? 1
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        if let team = teams?[indexPath.row]{
            cell.textLabel?.text = team.teamName
        }
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
                // 处理长按操作，例如弹出确认删除的提示框
                let alertController = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                    // 执行删除操作
                    self.deleteItem(at: indexPath)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }

    func deleteItem(at indexPath: IndexPath) {
        // 获取要删除的对象，假设您的数据源是 Realm 中的 Results<Item>
        if let teamToDelete = teams?[indexPath.row] {
            do {
                // 在写事务中执行删除操作
                try realm.write {
                    realm.delete(teamToDelete)
                }
                
                // 更新数据源以移除被删除的对象
                // 假设 items 是 Results<Item>，需要刷新它
                teams = realm.objects(Team.self)
                
                // 更新表视图以反映删除
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Error deleting item from Realm: \(error.localizedDescription)")
            }
        }
    }



    
    @IBAction func addButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Text", message: nil, preferredStyle: .alert)
        // 添加文本输入框
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter text"
        }
        
        // 添加确认按钮
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let text = alertController.textFields?.first?.text {
                do {
                    try self.realm.write {
                        let newTeam = Team()
                        newTeam.teamName = text
                        self.realm.add(newTeam)
                    }
                    // 更新数据源
                    self.teams = self.realm.objects(Team.self)
                    self.tableView.reloadData()
                } catch {
                    print("Error saving data to Realm: \(error.localizedDescription)")
                }
            }
        }//对比confirmAction与cancelAction，confirmAction多了一个handler功能
        
        // 添加取消按钮
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // 将按钮添加到 UIAlertController
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // 弹出 UIAlertController
        present(alertController, animated: true, completion: nil)
        
        
        if let realmURL = Realm.Configuration.defaultConfiguration.fileURL {
            print("Realm file location: \(realmURL)")
        }
        

    }

}

