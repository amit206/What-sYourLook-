//
//  FirebaseStorage.swift
//  What'sYourLook?
//
//  Created by admin on 13/04/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
import UIKit
import Firebase
//import CommonCrypto

class FirebaseStorage {
    
    static func saveImage(image:UIImage, callback:@escaping (String)->Void){
        let storageRef = Storage.storage().reference(forURL:
            "gs://whatsyourlook-d0b22.appspot.com/")
        
        let data = image.jpegData(compressionQuality: 0.8)
        
        //TODO: replace "image" with user id
        let imageName:String = "image" + self.getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate()) + String(Int.random(in: 1..<99999999999));
        let imageRef = storageRef.child(imageName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
    
    static func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        let objDateformat: DateFormatter = DateFormatter()
        objDateformat.dateFormat = "yyyy-MM-dd"
        let strTime: String = objDateformat.string(from: dateToConvert as Date)
        let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
//    static func getMD5(data: Data) -> String {
//        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//        var d =  data.withUnsafeBytes { bytes in
//            CC_MD5(bytes, CC_LONG(data.count), &digest)
//        }
//        var digestHex = ""
//        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
//            digestHex += String(format: "%02x", digest[index])
//        }
//        return digestHex
//    }
    
}
