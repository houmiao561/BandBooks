//
//  Main0ViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/22.
//

import UIKit

class Main0ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func VocalButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Main0ToTable0", sender: sender)
    }
    
}
