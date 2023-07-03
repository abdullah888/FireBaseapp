//
//  Details.swift
//  GOOne
//
//  Created by abdullah on 12/12/1444 AH.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct Details: View {
    var product : ProductModel
    var body: some View {
        NavigationStack{
            HStack{
                Spacer()
                Text("معلومات")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }
            ZStack{
                Color.black.edgesIgnoringSafeArea(.all)
                VStack{
                   
                    VStack{
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
                    VStack{
                        HStack{
                            Spacer()
                                 Text(product.name!)
                                     .padding()
                             
                        }
                            Text(product.description!)
                              .font(.headline)
                              .foregroundColor(.white)
                              .multilineTextAlignment(TextAlignment.trailing)
                        
                    }
                    Spacer()
                    
                }
              
            }
        }
    }
}


