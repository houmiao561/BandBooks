//
//  MainController1.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/16.
//

import UIKit
import Photos
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseStorageUI


class MainController1: UIViewController{
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func downloadImage(_ sender: UIButton) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child("UploadPhotoOne")
        imageView.sd_setImage(with: ref)

        
    }
    @IBAction func addPhotoButton(_ sender: UIButton) {
        
        //imagePicker.sourceType = .photoLibrary
        //present(imagePicker,animated: true,completion: nil)
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion:nil)
    }
    
//    func uploadImageToFirebase(image: UIImage) {
//        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
//
//        let imageRef = storageRef.child("images123.jpg")
//
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
//            if let error = error {
//                print("上传错误: \(error.localizedDescription)")
//            } else {
//                print("Image uploaded successfully!")
//                // 在metadata中可以获取上传后的文件信息，例如下载URL
////                if let downloadURL = metadata?.downloadURL()?.absoluteString {
////                    print("Download URL: \(downloadURL)")
////                }
//            }
//        }
//    }
    
    func requsetAuthroizationHandler(status:PHAuthorizationStatus){
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            print("1")
        }else{
            print("2")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            print(url)
            uploadToCloud(fileURL: url)
        }
        imagePicker.dismiss(animated: true,completion: nil)
    }
    
    func uploadToCloud(fileURL:URL){
        let storage = Storage.storage()
        let data = Data()
        let storageRef = storage.reference()
        let localFile = fileURL
        let photoRef = storageRef.child("UploadPhotoOne")
        let uploadTesk = photoRef.putFile(from: localFile, metadata: nil) { (metedata,error) in
            guard let metedata = metedata else {
                print(error)
                return
            }
            print("11111111111")
        }
    }

}


extension MainController1: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        // 当用户选择或拍摄图像后调用此方法
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            // 处理所选图像
//            uploadImageToFirebase(image: pickedImage)
//        }
//
//        picker.dismiss(animated: true, completion: nil) // 关闭UIImagePickerController
//    }
    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        // 用户取消选择或拍摄时调用此方法
//        picker.dismiss(animated: true, completion: nil) // 关闭UIImagePickerController
//    }
    
//    func uploadImageToFirebase(image: UIImage) {
//        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
//
//        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
//
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
//            if let error = error {
//                print("Error uploading image: \(error.localizedDescription)")
//            } else {
//                print("Image uploaded successfully!")
//                // 在metadata中可以获取上传后的文件信息，例如下载URL
//                if let downloadURL = metadata?.downloadURL()?.absoluteString {
//                    print("Download URL: \(downloadURL)")
//                }
//            }
//        }
//    }
    

}

