//
//  Cart.swift
//  CoffeShop
//
//  Created by Febrico Jonata on 04/12/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class Cart: ObservableObject, Identifiable, Decodable{
    var id = UUID()
    var product: Product
    var quantity: Int
    var size: String
    var price: Double
    
    init(product: Product, quantity: Int, size: String, price: Double) {
        self.product = product
        self.quantity = quantity
        self.size = size
        self.price = price
    }
}
