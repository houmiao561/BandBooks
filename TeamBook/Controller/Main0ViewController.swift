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
    var backButtonHide: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButtonStyle(vocalButton)
        changeButtonStyle(guitarButton)
        changeButtonStyle(bassButton)
        changeButtonStyle(drumButton)
        changeButtonStyle(keyboardButton)
        changeButtonStyle(otherInstrumentButton)
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        navigationItem.title = "BandBook"
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
    
    private func changeButtonStyle(_ button: UIButton){
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
    }
    
    
    @IBAction func SetButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Main0ToSet", sender: self)
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
