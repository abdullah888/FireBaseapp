//
//  AllProducts.swift
//  GOOne
//
//  Created by abdullah on 14/12/1444 AH.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct AllProducts: View {
    @StateObject var Producttdata = ProductViewModel()
    var body: some View {
        NavigationStack {
            HStack{
                Spacer()
                Text("منشوراتي")
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
            }
           
        }
    }
}

struct AllProducts_Previews: PreviewProvider {
    static var previews: some View {
        AllProducts()
    }
}
