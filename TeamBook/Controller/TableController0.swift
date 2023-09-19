//
//  TableController0.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/19.
//

import UIKit
import RealmSwift

class TableController0: UITableViewController {
    
    let realm = try! Realm()
    var items : Results<Item>?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.title
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
                        let newItem = Item()
                        newItem.title = text
                        self.realm.add(newItem)
                    }
                    // 更新数据源
                    self.items = self.realm.objects(Item.self)
                    self.tableView.reloadData()
                } catch {
                    print("Error saving data to Realm: \(error.localizedDescription)")
                }
            }
        }
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

