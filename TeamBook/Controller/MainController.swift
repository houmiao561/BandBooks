//
//  MainController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/16.
//

import UIKit
class MainCroller: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register (UINib (nibName:"MainCell", bundle: nil),forCellReuseIdentifier: "MainCell")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
