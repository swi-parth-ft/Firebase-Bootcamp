//
//  ProductsManager.swift
//  Firebase Bootcamp
//
//  Created by Parth Antala on 8/14/24.
//

import Foundation
import FirebaseFirestore

final class ProductsManager {
    
    static let shared = ProductsManager()
    
    private init() {}
    
    private let productsCollection = Firestore.firestore().collection("products")
    
    private func productDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    func uploadProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    func getProduct(productId: String) async throws {
        try await productDocument(productId: productId).getDocument(as: Product.self)
    }
    
    func getAllProducts() async throws -> [Product] {
        try await productsCollection.getDocuments(as: Product.self)
        
    }
}

extension Query {
    
    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        
        let snapShot = try await self.getDocuments()
        
        return try snapShot.documents.map({ document in
                try document.data(as: T.self)
        })
    }
}
