//
//  ProductModel.swift
//  GOOne
//
//  Created by abdullah on 08/12/1444 AH.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI



class ProductModel  :Identifiable  {

   
    var id : String?
    var name : String?
    var description : String?
    var image: String?
 
  
   
    
    init(id : String,name : String, description : String, image : String) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
 
    }
    
    init(Dictionary : [String : AnyObject]) {
        self.id = Dictionary["id"] as? String
        self.name = Dictionary["name"] as? String
        self.description = Dictionary["description"] as? String
        self.image = Dictionary["image"] as? String

        
    }
    
    func MakeDictionary()->[String : AnyObject] {
        var D : [String : AnyObject] = [:]
        D["id"] = self.id as AnyObject
        D["name"] = self.name as AnyObject
        D["description"] = self.description as AnyObject
        D["image"] = self.image as AnyObject
        return D
    }
    
    func Upload(){
        guard let id = self.id else { return }
        Firestore.firestore().collection("Products").document(id).setData(MakeDictionary())
    }
    
    func Remove(){
        guard let id = self.id else { return }
        Firestore.firestore().collection("Products").document(id).delete()
        
       // Firestore.firestore().collection("Products").document(id).delete()
    }
    
    
}


class ProductsApi {

    static func GetProducts(id : String, completion : @escaping (_ Products : ProductModel)->()){
        Firestore.firestore().collection("Products").document(id).addSnapshotListener { (Snapshot : DocumentSnapshot?, Error : Error?) in
            if let data = Snapshot?.data() as [String : AnyObject]? {
                let New = ProductModel(Dictionary: data)
                completion(New)
            }
        }
    }
    
    static func GetAllProducts(completion : @escaping (_ Products : ProductModel)->()){
        Firestore.firestore().collection("Products").getDocuments { (Snapshot, error) in
            if error != nil { print("Error") ; return }
            guard let documents = Snapshot?.documents else { return }
            for P in documents {
                if let data = P.data() as [String : AnyObject]? {
                    let New = ProductModel(Dictionary: data)
                    completion(New)
                }
            }
        }

    }
    
}

