//
//  MessageViewModel.swift
//  GOOne
//
//  Created by abdullah on 08/12/1444 AH.
//

import SwiftUI
import Firebase

class MessageViewModel : ObservableObject{
  
    //Modell
    @Published var messages: [MessageModel] = []
    @Published  var Message = ""
 
    let ref = Firestore.firestore()
    
    
    init() {
        GetMessage()
   
    }

    func UploadMessage(){
        let db = Firestore.firestore()
        Auth.auth().addStateDidChangeListener { auth, user in
            db.collection("Messages")
                .document()
                .setData(["Message":self.Message]) { (err) in
                    if err != nil{
                        print((err?.localizedDescription)!)
                        return
                           }
                       }
            self.Message = ""
            }
        }
    

    func GetMessage(){
        ref.collection("Messages").addSnapshotListener { snap, err in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            guard let data = snap else{return}

            data.documentChanges.forEach { (doc) in
                if doc.type == .added{
                    MessageApi.GetMessage(ID: doc.document.documentID) { Message in
                        self.messages.append(Message)
                    }
                }
            }
        }
    }
    


}
