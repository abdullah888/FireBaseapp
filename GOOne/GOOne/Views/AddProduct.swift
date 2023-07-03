//
//  AddProduct.swift
//  GOOne
//
//  Created by abdullah on 10/12/1444 AH.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
struct AddProduct: View {
    @StateObject var Producttdata = ProductViewModel()
    @StateObject var Userdata = UserViewModel()
    @State var img_Data = Data.init(count: 0)
    @State var name = ""
    @State var description = ""
    @Environment(\.presentationMode) var presentationMode
    @State var picker = false
    @State private var showingAlert = false
    @State var showaduser = false
    var body: some View {
        NavigationStack {
            HStack{
                Spacer()
                Text("اضافة")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
               
            }
            ZStack{
                Color.black.edgesIgnoringSafeArea(.all)
                VStack{
                    VStack{
                        if img_Data.count != 0 {
                            Image(uiImage: UIImage(data: img_Data)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 3)
                            .clipShape(RoundedRectangle(cornerRadius:8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(.white, lineWidth: 0.1)
                                    )
                            
                        } else {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 100))
                                .foregroundColor(Color.white)
                                .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 3)
                                .clipShape(RoundedRectangle(cornerRadius:8))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .strokeBorder(.white, lineWidth: 0.1)
                                        )
                            }
                    }.onTapGesture(perform: {
                        self.picker = true
                    })
                    
                    
                    
                    VStack(spacing: 15){
                        TextField("Name", text: $name)
                            .font(.title)
                            .padding()
                            .multilineTextAlignment(TextAlignment.trailing)
                            .foregroundColor(.black)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        HStack{
                            Spacer()
                        Text("معلومات")
                                .foregroundColor(.white)
                              }
                        TextEditor(text: $description)
                        .font(.title)
                        .foregroundColor(.black)
                        .multilineTextAlignment(TextAlignment.trailing)
                        .scrollContentBackground(.hidden)
                        .background(.linearGradient(colors: [.white, .white], startPoint: .top, endPoint: .bottom))
                        .cornerRadius(10)
                        }
                    Button {
                        if Userdata.userInfo.ID != "" {
                           UploadProduct()
                        }else {
                            showingAlert = true
                        }
                    } label: {
                        Text("ارسال")
                            .font(.title)
                            .frame(width: 100,height: 55)
                            .background(.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .padding(.vertical,30)
                    }
                }
            }
        }.sheet(isPresented: $showaduser) {
         AddUser()
        }
        .sheet(isPresented: $picker) {
            ImagePicker(picker: $picker, img_Data: $img_Data)
        }
        .alert(isPresented:$showingAlert) {
            Alert(
                title: Text("يلزم التسجيل"),
                message: Text("من اجل النشر"),
                primaryButton: .destructive(Text("تسجيل")) {
                   showaduser = true
                },
                secondaryButton: .cancel()
            )
        }
    }
    func UploadProduct(){
        let db = Firestore.firestore()
        Auth.auth().addStateDidChangeListener { auth, user in
        UploadImage(imageData: self.img_Data, path: "Products_Image") { url in
            db.collection("Products")
                .document()
                .setData(["name":name,"description":description,"image":url]) { (err) in
                    if err != nil{
                        print((err?.localizedDescription)!)
                        return
                           }
                       }
                }
        }
        presentationMode.wrappedValue.dismiss()
    }
}




