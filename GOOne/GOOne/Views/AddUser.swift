//
//  AddUser.swift
//  GOOne
//
//  Created by abdullah on 14/12/1444 AH.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
struct AddUser:View {
    @StateObject var Userdata = UserViewModel()
    @State var img_Data = Data.init(count: 0)
    @State var Picker = false
    @Environment(\.presentationMode) var presentationMode
    @State var name = ""
    var body: some View {
        NavigationStack{
            HStack{
                Spacer()
                Text("تعديل واضافة")
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
                            .clipShape(Circle())
                            .frame(width: 200, height: 200)
                            .overlay(Circle().stroke(Color.white, lineWidth: 0.1))
                            .shadow(radius: 2)
                            .padding(.bottom, 1)
                        HStack{
                        Text("تغير الصورة")
                            .font(.headline)
                            .foregroundColor(.white)
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            }
                        } else {
                            VStack {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 200, height: 200)
                                    .overlay(Circle().stroke(Color.white, lineWidth: 0.1))
                                    .shadow(radius: 2)
                                    .padding(.bottom, 1)
                                HStack{
                                Text("اختيار صورة من الاستوديو")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    Image(systemName: "plus.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                }
                        }
                    }
                    
                }
                .onTapGesture(perform: {
                    self.Picker.toggle()
                })
                .padding()
                VStack{
                    TextField("الاسم", text: $name)
                        .font(.title)
                        .padding()
                        .multilineTextAlignment(TextAlignment.trailing)
                        .foregroundColor(.black)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .padding()
                    Button {
                       addUser()
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
        }.sheet(isPresented: $Picker) {
            ImagePicker(picker: self.$Picker, img_Data: self.$img_Data)
           }
       
        }
    }
    func addUser(){
       
        Auth.auth().signInAnonymously { (res, err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            print("Success = \(res!.user.uid)")
            UploadImage(imageData: img_Data, path: "User_Image") { url in
                DispatchQueue.main.async {
                UserModel(ID: res!.user.uid, Name: name, UserImage: url).Upload()
                }
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
}
struct AddUser_Previews: PreviewProvider {
    static var previews: some View {
        AddUser()
    }
}
