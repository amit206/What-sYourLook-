//
//  ModelFirebase.swift
//  What'sYourLook?
//
//  Created by admin on 05/04/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation

class ModelFirebase{
    
    func add(post:Post){
//        let db = Firestore.firestore()
//        // Add a new document with a generated ID
//        var ref: DocumentReference? = nil
//        ref = db.collection("students").addDocument(data: student.toJson(), completion: { err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("Document added with ID: \(ref!.documentID)")
//                }
//        })
    }
    
    func getAllPosts()->[Post]{
//        (callback: @escaping ([Post]?)->Void){
//        let db = Firestore.firestore()
//        db.collection("students").getDocuments { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//                callback(nil);
//            } else {
//                var data = [Student]();
//                for document in querySnapshot!.documents {
//                    data.append(Student(json: document.data()));
//                }
//                callback(data);
//            }
//        };
        return [Post]()
    }
    
    func addLike(postId:String){
//        postModelSql.addLike(postId:postId)
    }
    func removeLike(postId:String){
//        postModelSql.removeLike(postId:postId)
    }
}
