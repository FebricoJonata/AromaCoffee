//
//  ProductViewModel.swift
//  CoffeShop
//
//  Created by Febrico Jonata on 07/12/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class ProductViewModel: ObservableObject{
    @Published var products: [Product] = []
    
    init() {
        Task{
            await fetchProduct()
        }
    }
    
    func fetchProduct() async {
        do {
            let snapshot = try await Firestore.firestore().collection("products").getDocuments()

            self.products = snapshot.documents.compactMap { document in
                do {
                    let product = try document.data(as: Product.self)
//                    print("Product Print: \(product)")
                    return product
                } catch {
                    print("Error decoding product: \(error.localizedDescription)")
                    return nil
                }
            }
//            for document in snapshot.documents {
//                print("Raw Data: \(document.data())")
//            }
            
        } catch {
            if !Task.isCancelled {
                print("Error fetching products: \(error.localizedDescription)")
            }
        }
    }
}
