//
//  ModelFirebase.swift
//  What'sYourLook?
//
//  Created by admin on 05/04/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
import Firebase

class ModelFirebase{
    
    func addPost(post:Post){
        let db = Firestore.firestore()
        // Add a new document with a generated ID
        //        var ref: DocumentReference? = nil
        //        ref = db.collection("posts").addDocument(data: [
        //            "PST_ID": "1",
        //            "USR_ID":"2",
        //            "PST_TEXT":"lala check fire",
        //            "IMG_URL":"sa",
        //            "DATE":"01/01/2020"
        //            ]) { err in
        let json = post.toJson()
        db.collection("posts").document(post.id).setData( json ) {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
                ModelEvents.PostDataNotification.post()
            }
        }
    }
    
    func removePost(postId:String){
        let db = Firestore.firestore()
        db.collection("posts").document(postId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func getAllPosts(since:Int64, callback: @escaping ([Post]?)->Void){
        let db = Firestore.firestore()
        
        db.collection("posts").order(by: "lastUpdate").start(at: [Timestamp(seconds: since, nanoseconds: 1)]).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                callback(nil);
            } else {
                var data = [Post]();
                for document in querySnapshot!.documents {
                    if let ts = document.data()["lastUpdate"] as? Timestamp{
                        let tsDate = ts.dateValue();
                        print("\(tsDate)");
                        let tsDouble = tsDate.timeIntervalSince1970;
                        print("\(tsDouble)");
                        
                    }
                    data.append(Post(json: document.data()));
                }
                callback(data);
            }
        };
    }
    
    func addLike(postId:String){
        let db = Firestore.firestore()
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("likes").addDocument(data: [
            "PST_ID": postId,
            "USR_ID":"2"//TODO:
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func removeLike(postId:String){
        let db = Firestore.firestore()
        db.collection("likes").whereField("PST_ID", isEqualTo: postId).whereField("USR_ID", isEqualTo: "2").getDocuments() { (querySnapshot, err) in// TODO: usr_id
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }
}
