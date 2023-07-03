//
//  UserViewModel.swift
//  GOOne
//
//  Created by abdullah on 08/12/1444 AH.
//

import SwiftUI
import Firebase

class UserViewModel : ObservableObject{
    
    /*  // for add documentID
     let ref = firestore.collection(myCollection).document()
     // ref is a DocumentReference
     let id = ref.documentID
     */
    
    
    //Modell
    @Published var user: [UserModel] = []
    @Published  var Name = ""
    @Published var userInfo = UserModel(ID: "", Name: "", UserImage: "")
    @AppStorage("current_status") var status = false
    
    // Image Picker For Updating Image...
    @Published var picker = false
    @Published var img_Data = Data(count: 0)
    // Loading View..
    @Published var isLoading = false
    
    let ref = Firestore.firestore()
    let uiD = Auth.auth().currentUser?.uid
    
    init() {
        fetchUserData()
        GeUsers()
        Auth.auth().addStateDidChangeListener { auth, user in
            if let id = user?.uid{
            UserApi.GetUser(ID: id) { User in
                self.userInfo = User
               }
            }
        }
      
    }
    
    
    func logOut(){
        
        // logging out..
        
        try! Auth.auth().signOut()
        status = false
    }
    
    func updateImage(){
        
        isLoading = true
        Auth.auth().addStateDidChangeListener { auth, user in
            UploadImage(imageData: self.img_Data, path: "User_Image") { (url) in
            
            self.ref.collection("Users").document(user!.uid).updateData([
            
                "UserImage": url,
            ]) { [self] (err) in
                if err != nil{return}
                
                // Updating View..
                self.isLoading = false
                UserApi.GetUser(ID: user!.uid) { User in
                    self.userInfo = User
                   }
                }
            }
        }
    }
   
    func GeUsers(){
        Auth.auth().addStateDidChangeListener { auth, user in
            if let userid = user?.uid{
                UserApi.GetUser(ID: userid) { User in
                    self.user.append(User)
                   
                }
            }
            
        }
    }
    
    func fetchUserData(){
        
        let db = Firestore.firestore()
        
        db.collection("Users").getDocuments { (snap, err) in
            
            guard let productData = snap else{return}
            
            self.user = productData.documents.compactMap({ (doc) -> UserModel? in
               
                let ID = doc.documentID
                let Name = doc.get("Name") as! String
                let UserImage = doc.get("UserImage") as! String
                return UserModel(ID: ID, Name: Name, UserImage: UserImage)
               
           
                
            })
            
            self.user = self.user
        }
    }
    
    
    func login(){
        
        Auth.auth().signInAnonymously { (res, err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            print("Success = \(res!.user.uid)")
            
            // After Logging in Fetching Data
            
         //   self.fetchData()
        }
    }
    func deleteUser(id: String){
        let ref = Firestore.firestore()
        
        ref.collection("Users").document(id).delete { (err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
        }
    }
    func Delete(){
        user.forEach { (i) in
            deleteUser(id: i.ID!)
        }
    }

}
