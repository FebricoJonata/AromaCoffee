//
//  RegisterView.swift
//  CoffeShop
//
//  Created by Febrico Jonata on 30/11/23.
//

import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var name: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView{
            VStack{
                Text("Register Here!")
                    .font(.system(size: 32))
                    .bold()
                
                VStack (spacing: 24){
                    Form(attribute: $name, placeholder: "Enter Name Here", title: "Full Name")
                        .autocapitalization(.none)
                    
                    Form(attribute: $email, placeholder: "Enter Email Here", title: "Email Address")
                        .autocapitalization(.none)
                    
                    Form(attribute: $password, placeholder: "Enter Password Here", title: "Password", isSecureField: true)
                    
                    ZStack (alignment: .trailing){
                        Form(attribute: $confirmPassword, placeholder: "Enter Password Again", title: "Confirm Password", isSecureField: true)
                        
                        if !password.isEmpty && !confirmPassword.isEmpty{
                            if password == confirmPassword{
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            }else{
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }

                    
                }
                .padding(.horizontal)
                .padding(.top, 12)

                
                Button{
                    Task{
                        do{
                            try await authViewModel.createUser(withEmail: email,
                                                           password: password,
                                                           fullName: name)
                            
                        }catch{
                            print("Error creating user: \(error.localizedDescription)")
                        }
                    }
                    
                }label: {
                    Text("Register")
                        .frame(width: 100, height: 50)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .bold()
                        .padding()

                }
                
                HStack{
                    Text("Already Have an Account?")
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Login Here!")
                    }
                    .accentColor(.brown)
                }
                
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)

    }

}

#Preview {
    RegisterView()
}
