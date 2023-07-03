//
//  Setting.swift
//  GOOne
//
//  Created by abdullah on 10/12/1444 AH.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
struct Setting: View {
    @StateObject var Userdata = UserViewModel()
    @State var img_Data = Data.init(count: 0)
    @State var ShowAddUser = false
    @Environment(\.presentationMode) var presentationMode
    @State var name = ""
    @State var message = ""
    @State private var showingAlert1 = false
    @State private var showingAlert2 = false
    @State private var showGreeting = true
    var body: some View {
        NavigationStack{
            HStack{
                Spacer()
                Text("الاعدادات")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                VStack{
                   
                        if Userdata.userInfo.UserImage != ""{
                            WebImage(url: URL(string: Userdata.userInfo.UserImage!))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius:8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(.white, lineWidth: 0.1)
                                    )
                            
                        } else {
                            VStack {
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius:8))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .strokeBorder(.white, lineWidth: 0.1)
                                            )
                        }
                    }
                }
                .onTapGesture(perform: {
                    self.ShowAddUser.toggle()
                })
                .padding()
               
                    VStack{
                        if Userdata.userInfo.Name != "" && Userdata.userInfo.ID != "" {
                            Text(Userdata.userInfo.Name!)
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                            Text("مصمم ومطور تطبيقات ios")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                        } else {
                            Text("الاسم")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                            Text("ID")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                            
                        }
                   
                    }
                
                VStack{
                    Toggle(isOn: $showGreeting, label: {
                       
                        SettingsRow(title: "نمط الطيران", imageName: "airplane")
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 15))
                         })
                    .onChange(of: showGreeting) { value in
                        if showGreeting != false {
                            showingAlert2 = true
                        }else {
                            showingAlert1 = true
                        }
                               }
                        
                    NavigationLink(destination: AddUser()) {
                        SettingsRow(title: "تعديل بياناتي", imageName: "person.fill")
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 15))
                    }
                    
                    NavigationLink(destination: AllProducts()) {
                        SettingsRow(title: "منشوراتي", imageName: "camera.macro")
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        SettingsRow(title: "Privacy Policy", imageName: "lock.fill")
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    }
                    
                    
                    Button(action: {
                        print("Sign Out")
                    }) {
                        SettingsRow(title: "Sign Out", imageName: "square.and.arrow.up.fill")
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    }
                }
                .padding()
                .background(
                    Color(.black)
                        .cornerRadius(16)
                )
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                Spacer()
            }
        }.sheet(isPresented: $ShowAddUser) {
            AddUser()
            }
        .alert("تم تعطيل", isPresented: $showingAlert1) {
                    Button("OK", role: .cancel) { }
                }
        .alert("تم تفعيل", isPresented: $showingAlert2) {
                        Button("OK", role: .cancel) { }
                    }
        }
    }
}

struct SettingsRow: View {
    var title: String
    var imageName: String
    
    var body: some View {
        
        HStack(spacing: 10) {
            Image(systemName: imageName)
                .frame(width: 24, height: 24)
                .font(.system(size: 20, weight: .semibold))
                .padding(10)
                .background(
                    Color(.black)
                        .cornerRadius(8)
                )
                .foregroundColor(Color(.white))
            Text(title)
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            Spacer()
        }
            
    }
}





