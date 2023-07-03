//
//  UploadImage.swift
//  GOOne
//
//  Created by abdullah on 08/12/1444 AH.
//

import SwiftUI
import Firebase
import FirebaseStorage


func UploadImage(imageData: Data,path: String,completion: @escaping (String) -> ()){
    
    let storage = Storage.storage().reference()
    let uid = Auth.auth().currentUser!.uid
    
    storage.child(path).child(uid).putData(imageData, metadata: nil) { (_, err) in
        
        if err != nil{
            completion("")
            return
            
        }
        
        // Downloading Url And Sending Back...
        
        storage.child(path).child(uid).downloadURL { (url, err) in
            if err != nil{
                completion("")
                return
                
            }
            completion("\(url!)")
        }
    }
}






//لتحميل اكثر من صور لاي تطبيق بعد تعديل اسم ملف child


class XUpload {
    //غير اسم ملف child in storge الى اسم الاسم التابعة له الصور
    static func UploadImage(Image : UIImage , completion : @escaping (_ url : String)->()) {
        guard let dataImg = Image.pngData() else { return }
        let storage = Storage.storage().reference()
        let imagesRef = storage.child("Product_Images").child(UUID().uuidString)
        imagesRef.putData(dataImg, metadata: nil) { (meta, error) in
            imagesRef.downloadURL { (url, error) in
                guard let str = url?.absoluteString else { return }
                completion(str)
            }
        }
    }

}

extension UIImage {
    
    func Upload(completion : @escaping (_ url : String)->()) {
        XUpload.UploadImage(Image: self.resizeImage(image: self, targetSize: CGSize(width: 500, height: 500))) { (Url) in completion(Url) }
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    
    
}



