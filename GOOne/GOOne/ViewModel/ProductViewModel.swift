//
//  ProductViewModel.swift
//  GOOne
//
//  Created by abdullah on 08/12/1444 AH.
//

import SwiftUI
import Firebase


class ProductViewModel :ObservableObject{
    
    
    /*  // for add documentID
     let ref = firestore.collection(myCollection).document()
     // ref is a DocumentReference
     let id = ref.documentID
     */
   
    // PeoductObject
    @Published var products: [ProductModel] = []
    @Published var Productdatas = [ProductModel]()
    // product
    @Published var name = ""
    @Published var description = ""
    // Image Picker...
    @Published var picker = false
    @Published var img_Data = Data(count: 0)
    @Published var isLoading = false
    
    let ref = Firestore.firestore()
    
    init(){
       // GetProduct()
     GetAllProduct()
      // fetchData()
    }
    
    
    func UploadProduct(){
        let db = Firestore.firestore()
        Auth.auth().addStateDidChangeListener { auth, user in
        UploadImage(imageData: self.img_Data, path: "Products_Image") { url in
            db.collection("Products")
                .document()
                .setData(["name":self.name,"description":self.description,"image":url]) { (err) in
                    if err != nil{
                        print((err?.localizedDescription)!)
                        return
                    }
                }
            }
        }
    }
 
    func GetAllProduct(){
        
        let db = Firestore.firestore()
       
            db.collection("Products").addSnapshotListener { (snap, err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
                
                for i in snap!.documentChanges{
                    
                    let id = i.document.documentID
                    let name = i.document.get("name") as! String
                    let description = i.document.get("description") as! String
                    let image = i.document.get("image") as! String
                    self.products.append(ProductModel(id: id,name: name, description: description,image: image))
                    
           }
                
        }
    }
    
    //اضف الكود السريع وحط الاصافة من الهوم
    func GetProduct(){
        ref.collection("Products").addSnapshotListener { snap, err in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            guard let data = snap else{return}

            data.documentChanges.forEach { (doc) in
                if doc.type == .added{
                 
                    ProductsApi.GetAllProducts { Products in
                        ProductsApi.GetProducts(id: Products.id!) { Products in
                            
                        }
                    }
                  
                }
            }
        }
    }
    func fetchData(){
        
        let db = Firestore.firestore()
        
        db.collection("Products").getDocuments { (snap, err) in
            
            guard let productData = snap else{return}
            
            self.products = productData.documents.compactMap({ (doc) -> ProductModel? in
                
                let id = doc.documentID
                let name = doc.get("name") as! String
                let description = doc.get("description") as! String
                let image = doc.get("image") as! String
                return ProductModel(id: id, name: name, description: description,image: image)
                
            })
            
            self.products = self.products
        }
    }
    
   
    
    func deleteCollection(collection: String) {
      
        let db = Firestore.firestore()
           db.collection(collection).getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
                   return
               }

               for document in querySnapshot!.documents {
                   
                   print("Deleting \(document.documentID) => \(document.data())")
                   document.reference.delete()
               }
           }
       }
    
   

    func addtoCart(){
        let db = Firestore.firestore()
        let id = Auth.auth().currentUser?.uid
        Productdatas.forEach { (product) in
        db.collection("Carts")
            .document(id!)
            .setData(["CartName":product.name!,
                      "CartImage":product.image!,
                      "UserID":id!,
                      "CartID":product.id!,
                      
            ]) { (err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
                
                // it will dismiss the recently presented modal....
                
            }
            
        }
    }
    
    
    
    
    // deleting Cart...
    
    func deletingProduct(id: String){
        let ref = Firestore.firestore()
        
        ref.collection("Products").document(id).delete { (err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
        }
    }
    func Delete(){
        products.forEach { (i) in
            deletingProduct(id: i.id!)
        }
    }
  
      
}










