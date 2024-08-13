//
//  UserManager.swift
//  Firebase Bootcamp
//
//  Created by Parth Antala on 8/13/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct UserModel {
    let userId: String
    let createdAt: Date?
    let email: String?
    let photoURL: String?
}

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        
        var data: [String : Any] = [
            "user_id" : auth.uid,
            "created_at" : Timestamp()
        ]
        
        if let email = auth.email {
            data["email"] = email
        }
        
        if let photoURL = auth.photoURL {
            data["photo_url"] = photoURL
        }
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(data, merge: false)
    }
    
    func getUser(userId: String) async throws -> UserModel {
        let snapShot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        guard let Userdata = snapShot.data(), let userId = Userdata["user_id"] as? String else {
            throw URLError(.badURL)
        }
        let createdAt = Userdata["created_at"] as? Date
            let email = Userdata["email"] as? String
            let photoURL = Userdata["photo_url"] as? String
            
        let user = UserModel(userId: userId, createdAt: createdAt, email: email, photoURL: photoURL)
            return user
        
    }
    
}
