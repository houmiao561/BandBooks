//
//  DetailViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/25.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var musicStyleLabel: UILabel!
    @IBOutlet weak var selfIntroduceText: UITextView!
    
    var smallFirebase = FirebaseDataArray(name: "", musicStyle: "", location: "", selfIntroduction: "", allEmailText: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = smallFirebase.name
        locationLabel.text = smallFirebase.location
        musicStyleLabel.text = smallFirebase.musicStyle
        selfIntroduceText.text = smallFirebase.selfIntroduction
    }
    
}
