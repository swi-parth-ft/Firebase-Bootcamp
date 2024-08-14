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
    
    func getAllProducts() async throws -> [Product] {
        let snapShot = try await productsCollection.getDocuments()
        
        var products: [Product] = []
        for document in snapShot.documents {
            let product = try document.data(as: Product.self)
            products.append(product)
        }
        
        return products
    }
}
