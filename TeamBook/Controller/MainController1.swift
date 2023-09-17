//
//  MainController1.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/16.
//

import UIKit
import Photos


class MainController1: UIViewController{
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addPhotoButton(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker,animated: true,completion: nil)
    }
}


extension MainController1: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 当用户选择或拍摄图像后调用此方法
        if let selectedImage = info[.originalImage] as? UIImage {
            // 处理所选图像
            imageView.image = selectedImage // 假设imageView是显示图像的UIImageView
        }
        
        picker.dismiss(animated: true, completion: nil) // 关闭UIImagePickerController
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 用户取消选择或拍摄时调用此方法
        picker.dismiss(animated: true, completion: nil) // 关闭UIImagePickerController
    }
}
