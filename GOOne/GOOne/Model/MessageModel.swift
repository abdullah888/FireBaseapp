//
//  MessageModel.swift
//  GOOne
//
//  Created by abdullah on 08/12/1444 AH.
//

import SwiftUI
import Foundation
import Firebase

class MessageModel :Identifiable {
    
    var ID : String?
    var Message : String?
   
    init(ID : String ,  Message : String ) {
        self.ID = ID
        self.Message = Message
        
       
      
    }
    
    init(Dictionary : [String : AnyObject]) {
        self.ID = Dictionary["ID"] as? String
        self.Message = Dictionary["Message"] as? String
       
        
    }
    
    func MakeDictionary()->[String : AnyObject] {
        var New : [String : AnyObject] = [:]
        New["ID"] = self.ID as AnyObject
        New["Message"] = self.Message as AnyObject
       
        
        return New
    }
    
    func Upload(){
        guard let id = self.ID else { return }
        Firestore.firestore().collection("Messages").document(id).setData(MakeDictionary())
    }
    
//    func Remove(){
//        guard let id = self.ID else { return }
//        Firestore.firestore().collection("Users").document(id).delete()
//    }
    
    
    
    
}


class MessageApi {
    
    
    static func GetMessage(ID : String, completion : @escaping (_ Message : MessageModel)->()){
        
        Firestore.firestore().collection("Messages").document(ID).addSnapshotListener { (Snapshot : DocumentSnapshot?, Error : Error?) in
            
            if let data = Snapshot?.data() as [String : AnyObject]? {
               let New = MessageModel(Dictionary: data)
                completion(New)
            }
            
        }
        
    }
    
    static func GetAllMessages(completion : @escaping (_ Message : MessageModel)->()){
        Firestore.firestore().collection("Messages").getDocuments { (Snapshot, error) in
            if error != nil { print("Error") ; return }
            guard let documents = Snapshot?.documents else { return }
            for P in documents {
                if let data = P.data() as [String : AnyObject]? {
                    let New = MessageModel(Dictionary: data)
                    completion(New)
                }
            }
        }

    }

    
    
}



