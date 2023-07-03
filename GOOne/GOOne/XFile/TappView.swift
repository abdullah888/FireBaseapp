//
//  TappView.swift
//  GOOne
//
//  Created by abdullah on 10/12/1444 AH.
//

import SwiftUI

struct TappView: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(.white)
      }
    var body: some View {
       
      return  TabView {
                   Home()
                       .tabItem {
                           Label("Menu", systemImage: "house.fill")
                       }

            Setting()
                .tabItem {
                    Label("Setting", systemImage: "list.dash")
                }
          
      }.accentColor(Color.gray)
    }
}

struct TappView_Previews: PreviewProvider {
    static var previews: some View {
        TappView()
    }
}
