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
        if segue.identifier == "Main0ToGuitar" {
            if let destinationVC = segue.destination as? TableControllerGuitar {
                // 将按钮的标识符传递给下一个页面
                if let button = sender as? UIButton {
                    destinationVC.buttonName = button.titleLabel!.text!
                }
            }
        }
    }
    @IBAction func GuitarButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Main0ToGuitar", sender: sender)
    }
    @IBAction func BassButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Main0ToTable0", sender: sender)
    }
    @IBAction func DrumButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Main0ToTable0", sender: sender)
    }
    @IBAction func KeyboardButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Main0ToTable0", sender: sender)
    }
    @IBAction func OtherInstrumentButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Main0ToTable0", sender: sender)
    }
   
}
