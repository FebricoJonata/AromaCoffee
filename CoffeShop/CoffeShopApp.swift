//
//  CoffeShopApp.swift
//  CoffeShop
//
//  Created by Febrico Jonata on 28/11/23.
//

import SwiftUI
import Firebase

@main
struct CoffeShopApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var productViewModel = ProductViewModel()
    @StateObject var cartViewModel = CartViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(productViewModel)
                .environmentObject(cartViewModel)
        }
    }
}
