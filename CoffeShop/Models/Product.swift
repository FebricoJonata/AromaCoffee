//
//  Product.swift
//  CoffeShop
//
//  Created by Febrico Jonata on 04/12/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Product: Decodable {
//    var id: String
    var name: String
    var price: Double
    var description: String
    var img: String    
}
