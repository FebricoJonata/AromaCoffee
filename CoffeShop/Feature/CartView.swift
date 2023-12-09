//
//  CartView.swift
//  CoffeShop
//
//  Created by Febrico Jonata on 04/12/23.
//

import SwiftUI
import URLImage
import Firebase
import FirebaseFirestoreSwift

struct CartView: View {
    @State var totalPrice = 0.0
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
        VStack{
            
            List {
                ForEach(cartViewModel.cartItems) { cartItem in
                    // Display each item in the cart
                    CartItemView(cartItem: cartItem)
                }
                .onDelete { indices in
                    // Delete items at the specified indices when the delete button is tapped
                    cartViewModel.deleteCartItems(at: indices)
                }
            }
            
            
            Spacer()
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.brown)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    .frame(width: 350, height: 120)
                
                VStack{
                    Text("Total Price")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                        .frame(width: 350, alignment: .leading)
                        .padding(.leading, 60)
                    
                    Text(String(format: "$%.2f", cartViewModel.totalPrice))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                        .font(.system(size: 28))
                        .frame(width: 350, alignment: .leading)
                        .padding(.leading, 60)
                }
                
                Button(){
                    guard let firebaseAuthUser = Auth.auth().currentUser,
                          !cartViewModel.cartItems.isEmpty else {
                        print("Unable to complete purchase.")
                        return
                    }

                    let customUser = User(id: firebaseAuthUser.uid,
                                          fullName: firebaseAuthUser.displayName ?? "",
                                          email: firebaseAuthUser.email ?? "")

                    cartViewModel.setUser(customUser)
                    cartViewModel.purchaseItems()
                    print("Item has Been purchase")
                }label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder()
                            .frame(width: 120, height: 50)
                            .foregroundColor(.white)
                        
                        Text("Pay Now")
                            .foregroundColor(.white)
                            .bold()
                    }
                }.offset(x: 80)
            }
        }.onAppear {
            cartViewModel.calculateTotalPrice()
        }
    }
}

#Preview {
    CartView()
}

struct CartItemView: View {
    @ObservedObject var cartItem: Cart
    @EnvironmentObject var cartViewModel: CartViewModel
    
    
    var body: some View {
        VStack {
            HStack() {
                URLImage(URL(string: cartItem.product.img)!) { proxy in proxy
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(16)
                        .padding(.horizontal, 7)
                }
                Text("\(cartItem.product.name) (\(cartItem.size))")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            
            Spacer()
            Stepper(value: Binding(
                get: { cartItem.quantity },
                set: { newValue in
                    cartViewModel.updateCartItemQuantity(cartItem: cartItem, newQuantity: newValue)
                    cartViewModel.calculateTotalPrice()
                }
            ), in: 1...100) {
                Text("Quantity: \(cartItem.quantity)")
            }
            .onChange(of: cartItem.quantity) { newValue in
                // Update the quantity in the cartViewModel when the stepper value changes
                cartViewModel.updateCartItemQuantity(cartItem: cartItem, newQuantity: newValue)
            }
        }
        .padding()
    }
}



