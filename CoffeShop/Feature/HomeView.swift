//
//  HomeView.swift
//  CoffeShop
//
//  Created by Febrico Jonata on 30/11/23.
//

import SwiftUI
import URLImage

struct HomeView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection,
                content:  {
            HomeContentView().tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }.tag(0)
            CartView().tabItem {
                Image(systemName: "cart.fill")
                Text("Cart")
            }.tag(1)
            
            ProfileView().tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }.tag(2)
        })
        .accentColor(.brown)
        .navigationBarBackButtonHidden(true)
        
    }
    
    
}

#Preview {
    HomeView()
}



struct HomeContentView: View {
    
    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var cartViewModel: CartViewModel

    @State private var selectedIndex: Int = 0
    private var categories = ["All", "Cappucino", "Machiato", "Latte", "Americano"]
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                VStack {
                    if let user = authViewModel.currentUser{
                        TopView(name: user.fullName)
                        
                    }
                    SearchBar()
                }
                .background(Color.primary.opacity(0.9))
                
                
                Spacer()
                ScrollView (.horizontal, showsIndicators: false){
                    HStack {
                        ForEach(categories.indices, id: \.self) { i in
                            CategoryTabBar(isActive: i == selectedIndex, text: categories[i])
                                .onTapGesture {
                                    selectedIndex = i
                                }
                        }
                    }
                }
                .padding(.top, 80)
                .padding(.bottom, 15)
                
                ScrollView(.horizontal, showsIndicators: false){
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 5), GridItem(.flexible(), spacing: 10)], spacing: 5) {
                        ForEach(0..<productViewModel.products.count, id: \.self) { index in
                            NavigationLink(destination: ItemDetailView(product: productViewModel.products[index])) {
                                if index % 2 == 0 {
                                    CardItem(imageURL: productViewModel.products[index].img, name: productViewModel.products[index].name, price: productViewModel.products[index].price){
                                        cartViewModel.addItemToCart(product: productViewModel.products[index], quantity: 1, size: "S", price: productViewModel.products[index].price)

                                    }
                                } else {
                                    CardItem(imageURL: productViewModel.products[index].img,
                                             name: productViewModel.products[index].name, price: productViewModel.products[index].price){
                                        cartViewModel.addItemToCart(product: productViewModel.products[index], quantity: 1, size: "S", price: productViewModel.products[index].price)

                                    }
                                }
                            }
                        }
                        .padding(15)
                        .padding(.leading, 10)
                    }
                }
            }
        }
    }
}

struct CategoryTabBar: View {
    let isActive: Bool
    let text: String
    var body: some View {
        VStack {
            Text(text)
                .bold()
                .foregroundColor(isActive ? .brown : .black.opacity(0.5))
            if (isActive){
                Color(Color.brown)
                    .frame(width: 50, height: 2)
                    .clipShape(Capsule())
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        
        
    }
}

struct TopView: View {
    var greeting: String{
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
    
    var name: String
    
    var body: some View {
        HStack{
            VStack (alignment: .leading, content: {
                Text("\(greeting), ")
                    .font(.system(size: 18))
                    .foregroundColor(.brown)
                    .bold()
                Text(name)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
            })
            
            Spacer()
            Image("profile")
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(10)
                .foregroundColor(.gray)
        }
        .padding()
        .padding(.horizontal)
    }
}

struct SearchBar: View {
    @State private var text: String = ""
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white)
            TextField("Search", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .colorScheme(.dark)
                .accentColor(.white)
                .bold()
            
            Image(systemName: "line.horizontal.3.decrease.circle")
                .font(.system(size: 24))
                .foregroundColor(.brown)
            
        }
        .frame(width: 300, height: 50)
        .padding(.horizontal)
        .background(RoundedRectangle(cornerRadius: 8)
            .stroke(Color.brown, lineWidth: 0.5))
        .padding()
        .padding(.bottom, 85)
        .overlay(
            Image("promo")
                .cornerRadius(10)
                .frame(width: 340, height: 130)
                .foregroundColor(.gray)
                .padding(.top, 170)
            
        )
    }
}

struct CardItem: View {
    let imageURL: String
    let name: String
    let price: Double
    let maxWords: Int = 2
    
    var truncatedName: String {
        let words = name.components(separatedBy: " ")
        return words.prefix(maxWords).joined(separator: " ")
    }
    var addToCartAction: () -> Void
    
    var body: some View {
        
            VStack(alignment: .leading){
                URLImage(URL(string: imageURL)!) { proxy in proxy
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 135)
                        .cornerRadius(18)
                }
                
                Text(truncatedName)
                    .foregroundColor(.black.opacity(0.8))
                    .font(.title3)
                    .bold()
                
                HStack{
                    Text(String(format: "$%.2f", price))
                        .font(.system(size: 24))
                        .foregroundColor(.brown)
                        .bold()
                    
                    Button("+") {
                        print("Add Item to Cart")
                        addToCartAction()
                    }
                    .frame(width: 35, height: 35)
                    .foregroundColor(.white)
                    .background(.brown)
                    .cornerRadius(10)
                    .padding(.leading, 35)
                }
                
            }
        
    }
}
