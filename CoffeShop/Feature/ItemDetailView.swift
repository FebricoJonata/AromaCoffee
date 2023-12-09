//
//  ItemDetailView.swift
//  CoffeShop
//
//  Created by Febrico Jonata on 01/12/23.
//

import SwiftUI
import URLImage

struct ItemDetailView: View {
    var product: Product
    var body: some View {
        
        ScrollView (.vertical, showsIndicators: false){
            URLImage(URL(string: product.img)!) { proxy in proxy
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 330, height: 220)
                    .padding(.top, 20)
                    .cornerRadius(10)
            }
            
            HeaderView(name: product.name)
            Line()
            DescriptionView(description: product.description)
            SizeView(product: product)
            
            Spacer()
        }
        .navigationBarTitle("Detail", displayMode: .inline)
    }
    
}

//#Preview {
//    ItemDetailView()
//}

struct HeaderView: View {
    var name: String
    var body: some View {
        HStack{
            VStack (alignment: .leading){
                Text(name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                HStack (){
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("4.8")
                        .font(.system(size: 18))
                        .bold()
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 3)
            }
            
            Spacer()
            Image("Coffe-icon")
        }
        .padding()
        .padding(.horizontal, 20)
    }
}

struct DescriptionView: View {
    @State private var showFullDescription = false
    var description: String
    var body: some View {
        VStack (alignment: .leading){
            Text("Description")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
            
            
            Text(description)
                .lineLimit(showFullDescription ? nil : 3)
            
            Button(action: {
                showFullDescription.toggle()
            }) {
                Text(showFullDescription ? "Read Less" : "Read More")
                    .foregroundColor(.brown)
            }
        }.padding(.horizontal)
    }
}

struct SizeView: View {
    @State private var selectedSize: String?
    @EnvironmentObject var cartViewModel: CartViewModel
    var product: Product
    
    var adjustedPrice: Double {
        switch selectedSize {
        case "S":
            return product.price * 1.0
        case "M":
            return product.price * 1.35
        case "L":
            return product.price * 2.0
        default:
            return product.price
        }
    }
    
    var body: some View {
        VStack (alignment: .leading){
            Text("Size")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .padding(.top, 10)
            
            HStack{
                ForEach(["S", "M", "L"], id: \.self) { size in
                    Button(action: {
                        selectedSize = size
                    }) {
                        Text(size)
                            .frame(width: 30, height: 40, alignment: .center)
                            .foregroundColor(.brown)
                            .padding(.horizontal, 30)
                            .cornerRadius(10)
                        
                    }
                    .padding(.horizontal, 8)
                    .background(selectedSize == size ? Color.brown.opacity(0.3) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.brown, lineWidth: 2)
                    )
                    .opacity(selectedSize == size ? 1 : 0.6)
                }
            }
            .padding(.bottom, 30)
            
            Line()
                .padding(.bottom, 20)
            
            HStack{
                VStack{
                    Text("Price")
                        .foregroundStyle(.gray)
                    Text(String(format: "$%.2f", adjustedPrice))
                        .font(.title)
                        .foregroundColor(.brown)
                        .bold()
                }
                
                Spacer()
                
                Button("Buy Now") {
                    addItemToCart()
                }
                .frame(width: 100, height: 50, alignment: .center)
                .foregroundColor(.white)
                .background(Color.brown)
                .bold()
                .cornerRadius(10)
                
            }.padding(.horizontal, 10)
            
            
        }.padding()
    }
    
    func addItemToCart() {
        guard let selectedSize = selectedSize else {
            // Handle the case where no size is selected
            return
        }
        
        // Add the cartItem to the cartViewModel
        cartViewModel.addItemToCart(product: product, quantity: 1, size: selectedSize, price: adjustedPrice)
        self.selectedSize = nil
    }
}

struct Line: View {
    var body: some View {
        Color(Color.black.opacity(0.4))
            .frame(width: 350, height: 1)
    }
}
