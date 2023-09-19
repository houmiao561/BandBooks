//
//  UserDataManager.swift
//  TeamBook
//
//  Created by 侯淼 on 2023/9/19.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class UserDataManager {
    static let shared = UserDataManager()

    func saveUserData(teamName0: String) {
        // 保存用户数据到 Firebase 数据库
        if let currentUser = Auth.auth().currentUser {
            let userData = ["teamName0": teamName0]

            let userRef = Database.database().reference().child("users").child(currentUser.uid)
            userRef.setValue(userData) { (error, reference) in
                if let error = error {
                    print("Error writing user data: \(error.localizedDescription)")
                } else {
                    print("User data written successfully")
                }
            }
        }
    }

    func getUserData(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // 从 Firebase 数据库中获取用户数据
        if let currentUser = Auth.auth().currentUser {
            let userRef = Database.database().reference().child("users").child(currentUser.uid)
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                if let userData = snapshot.value as? [String: Any] {
                    completion(.success(userData))
                } else {
                    let error = NSError(domain: "UserDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "User data not found"])
                    completion(.failure(error))
                }
            }
        }
    }
}

