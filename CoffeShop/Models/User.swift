//
//  User.swift
//  CoffeShop
//
//  Created by Febrico Jonata on 03/12/23.
//

import Foundation

struct User : Identifiable, Codable{
    let id: String
    let fullName: String
    let email: String
    
    var initials: String{
        let formatter = PersonNameComponentsFormatter()
        formatter.style = .abbreviated
        if let components = formatter.personNameComponents(from: fullName){
            let formattedString = formatter.string(from: components)
            return formattedString
        }
        return ""
    }
}

