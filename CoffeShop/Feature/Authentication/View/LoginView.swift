//
//  LoginView.swift
//  CoffeShop
//
//  Created by Febrico Jonata on 30/11/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView{
            VStack{
                Text("Login Here!")
                    .font(.system(size: 32))
                    .bold()
                
                VStack (spacing: 24){
                    Form(attribute: $email, placeholder: "Enter Email Here", title: "Email Address")
                        .autocapitalization(.none)
                    
                    Form(attribute: $password, placeholder: "Enter Password Here", title: "Password", isSecureField: true)
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                
                Button{
                    Task{
                        try await authViewModel.signIn(withEmail: email, password: password)
                    }
                }label: {
                    Text("Login")
                        .frame(width: 100, height: 50)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .bold()
                        .padding()

                }
        
                
                HStack{
                    Text("Doesn't Have an Account?")
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("Register Here!")
                            .accentColor(.brown)
                    }
                }
                

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
        
}

#Preview {
    LoginView()
}

struct Form: View {
    @Binding var attribute: String
    let placeholder : String
    let title: String
    var isSecureField = false
    var body: some View {
        VStack (alignment: .leading, spacing: 12){
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if(isSecureField){
                SecureField(placeholder, text: $attribute)
                    .font(.system(size: 14))
            }else{
                TextField(placeholder, text: $attribute)
                    .font(.system(size: 14))
            }
            
            Divider()
        }

    }
}
