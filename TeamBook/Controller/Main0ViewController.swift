//
//  Main0ViewController.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/22.
//

import UIKit

class Main0ViewController: UIViewController {
    @IBOutlet weak var vocalButton: UIButton!
    @IBOutlet weak var guitarButton: UIButton!
    @IBOutlet weak var bassButton: UIButton!
    @IBOutlet weak var drumButton: UIButton!
    @IBOutlet weak var keyboardButton: UIButton!
    @IBOutlet weak var otherInstrumentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vocalButton.layer.borderColor = UIColor.black.cgColor
        vocalButton.layer.borderWidth = 1.0
        vocalButton.layer.cornerRadius = 10.0

        guitarButton.layer.borderColor = UIColor.black.cgColor
        guitarButton.layer.borderWidth = 1.0
        guitarButton.layer.cornerRadius = 10.0
        
        bassButton.layer.borderColor = UIColor.black.cgColor
        bassButton.layer.borderWidth = 1.0
        bassButton.layer.cornerRadius = 10.0
        
        drumButton.layer.borderColor = UIColor.black.cgColor
        drumButton.layer.borderWidth = 1.0
        drumButton.layer.cornerRadius = 10.0
        
        keyboardButton.layer.borderColor = UIColor.black.cgColor
        keyboardButton.layer.borderWidth = 1.0
        keyboardButton.layer.cornerRadius = 10.0
        
        otherInstrumentButton.layer.borderColor = UIColor.black.cgColor
        otherInstrumentButton.layer.borderWidth = 1.0
        otherInstrumentButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func VocalButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Main0ToVocal", sender: sender)
    }
    @IBAction func GuitarButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Main0ToVocal", sender: sender)
    }
    @IBAction func BassButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Main0ToVocal", sender: sender)
    }
    @IBAction func DrumButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Main0ToVocal", sender: sender)
    }
    @IBAction func KeyboardButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Main0ToVocal", sender: sender)
    }
    @IBAction func OtherInstrumentButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Main0ToVocal", sender: sender)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Main0ToVocal" {
            if let destinationVC = segue.destination as? TableControllerVocal {
                // 将按钮的标识符传递给下一个页面
                if let button = sender as? UIButton {
                    destinationVC.buttonName = button.titleLabel!.text!
                }
            }
        }
    }
}
