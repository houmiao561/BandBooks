//
//  MainController0.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/19.
//

import UIKit
class MainController0: ViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        performSegue(withIdentifier: "Main0ToMainTable0", sender: self)
    }
}
