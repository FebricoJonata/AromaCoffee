//
//  CartViewModel.swift
//  CoffeShop
//
//  Created by Febrico Jonata on 08/12/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class CartViewModel: ObservableObject{
    @Published var cartItems: [Cart] = []
    @Published var currentUser: User?
    @Published var totalPrice: Double = 0.0
    
    func addItemToCart(product: Product, quantity: Int, size: String, price: Double) {
        if let existingItemIndex = cartItems.firstIndex(where: { $0.product.name == product.name && $0.size == size}) {
            // If the item is already in the cart, update the quantity
            cartItems[existingItemIndex].quantity += quantity
        } else {
            // If the item is not in the cart, add a new cart item
            let newItem = Cart(product: product, quantity: quantity, size: size, price: price)
            cartItems.append(newItem)
        }
    }
    
    func updateCartItemQuantity(cartItem: Cart, newQuantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == cartItem.id }) {
            cartItems[index].quantity = newQuantity
        }
    }
    
    
    func deleteCartItems(at indices: IndexSet) {
        cartItems.remove(atOffsets: indices)
        calculateTotalPrice()
    }
    
    func calculateTotalPrice() {
        totalPrice = cartItems.reduce(0.0) { total, cartItem in
            let itemPrice = cartItem.price * Double(cartItem.quantity)
            return total + itemPrice
        }
    }
    
    func setUser(_ user: User) {
        self.currentUser = user
    }
    
    
    func purchaseItems(){
        
        // Ensure there are items in the cart and a user is logged in before proceeding
        guard !cartItems.isEmpty, let user = currentUser else {
            print("Cart is empty or user information is not available. Unable to complete purchase.")
            return
        }
        
        let purchasesCollection = Firestore.firestore().collection("transactions")
        
        let purchasedItemsData: [[String: Any]] = cartItems.map { cartItem in
            return [
                "productName": cartItem.product.name,
                "quantity": cartItem.quantity,
                "size": cartItem.size,
                "price": cartItem.price
            ]
        }
        
        let purchaseData: [String: Any] = [
            "username": user.fullName,
            "email": user.email,
            "purchasedItems": purchasedItemsData,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        purchasesCollection.addDocument(data: purchaseData) { error in
            if let error = error {
                print("Error adding purchase to Firestore: \(error)")
            } else {
                print("Purchase added to Firestore successfully.")
            }
        }
        
        //remove all item in cart
        cartItems.removeAll()
        
        calculateTotalPrice()
    }
}
