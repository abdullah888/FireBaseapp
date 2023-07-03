//
//  Home.swift
//  GOOne
//
//  Created by abdullah on 08/12/1444 AH.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI

struct Home: View {
    @StateObject var Producttdata = ProductViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var showAddProduct = false
    @State var ShowDetails = false
    var body: some View {
        NavigationStack {
            HStack{
                Spacer()
                Text("الصفحة الرئيسية")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }
            ZStack{
                Color.black.edgesIgnoringSafeArea(.all)
                VStack{
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(Producttdata.products){ product in
                            NavigationLink(destination: Details(product: product)) {
                                ProductCard(product: product)
                            }
                        }
                    }
                }
            }.sheet(isPresented: $showAddProduct, content: {
                AddProduct()
            })
            .preferredColorScheme(.dark)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                           showAddProduct = true
                        } label: {
                            Text("اضافة")
                                .font(.headline)
                                .foregroundColor(.white)
                        }

                        Button("Help") {
                            print("Help tapped!")
                        }
                    }
                }
        }
       
    }
   
}



struct ProductCard : View {
    var product : ProductModel
    var body: some View {
        VStack {
            WebImage(url: URL(string: product.image!))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 3)
                .clipShape(RoundedRectangle(cornerRadius:8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(.white, lineWidth: 0.1) 
                        )
        }
    }
}
