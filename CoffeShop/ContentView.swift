//
//  ContentView.swift
//  CoffeShop
//
//  Created by Febrico Jonata on 28/11/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group{
            if viewModel.userSession != nil{
                HomeView()
            }else{
                NavigationView{
                    VStack {
                        Image("splash")
                            .frame(height: 570)
                        
                        Text("Coffe so Good, your taste buds will love it.")
                            .font(.system(size: 34))
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                            
                            
                        
                        Text("The best grain, the finnest roast, the powerful flavor")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        NavigationLink (destination: LoginView()){
                            Text("Get Started")
                                .frame(width: 200, height: 50)
                                .background(Color.brown)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .bold()
                                .padding()
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }
            }
        }

        
    }
}

#Preview {
    ContentView()
}
