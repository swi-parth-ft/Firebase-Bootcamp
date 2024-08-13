//
//  UserManager.swift
//  Firebase Bootcamp
//
//  Created by Parth Antala on 8/13/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct UserModel: Codable {
    let userId: String
    let createdAt: Date?
    let email: String?
    let photoURL: String?
}

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: UserModel) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> UserModel {
        try await userDocument(userId: userId).getDocument(as: UserModel.self)
    }
    
    
}
