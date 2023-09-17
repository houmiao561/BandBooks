//
//  MainController1.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/16.
//

import UIKit
import FirebaseStorage

class MainController1: UIViewController{
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func downloadImage(_ sender: UIButton) {
        let storage = Storage.storage()
        // 创建 StorageReference，指向要下载的图像
        let storageRef = storage.reference().child("UploadPhotoOne")
        // 下载图像
        storageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] (data, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else if let data = data {
                // 将下载的数据转换为UIImage
                if let image = UIImage(data: data) {
                    // 在主线程上更新UI
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
    
    @IBAction func addPhotoButton(_ sender: UIButton) {
        self.imagePicker.sourceType = .photoLibrary //sourceType表示打开imagePicker的方式，这个方式为photoLibrary，打开相册
        self.present(self.imagePicker, animated: true, completion:nil)
    }
    
    //选择一张照片后这个函数被触发
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {//如果能从info中获取到url，就uploadToCloud
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            print("func imagePickerController 函数得到的url：\(url)")
            uploadToCloud(fileURL: url)
        }
        imagePicker.dismiss(animated: true,completion: nil)//关闭imagePicker
    }
    
    func uploadToCloud(fileURL:URL){
        let storage = Storage.storage()
        //let data = Data()
        let storageRef = storage.reference()
        let localFile = fileURL
        let photoRef = storageRef.child("UploadPhotoOne")
        let uploadTesk = photoRef.putFile(from: localFile, metadata: nil) { (metedata,error) in
            guard metedata != nil else {
                print("func uploadToCloud error!!!")
                return
            }
            print("func uploadToCloud")
        }
    }

}


extension MainController1: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

}

