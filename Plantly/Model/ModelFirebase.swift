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
    
    func updateLike(like:Like){
        let db = Firestore.firestore()
        
        let json = like.toJson()
        db.collection("likes").document(like.postId + like.usrId).setData( json ) {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
//                ModelEvents.PostDataNotification.post()//TODO: if weird errors check this
            }
        }
    }
    
    func addUser(profile:Profile){
        let db = Firestore.firestore()
        // Add a new document with a generated ID
        let json = profile.toJson()
        db.collection("users").document(profile.userName).setData( json ) {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
//                ModelEvents.PostDataNotification.post()
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
    
    func getAllProfiles(since:Int64, callback: @escaping ([Profile]?)->Void){//TODO
        let db = Firestore.firestore()
        
        db.collection("users").order(by: "lastUpdate").start(at: [Timestamp(seconds: since, nanoseconds: 1)]).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                callback(nil);
            } else {
                var data = [Profile]();
                for document in querySnapshot!.documents {
                    if let ts = document.data()["lastUpdate"] as? Timestamp{
                        let tsDate = ts.dateValue();
                        //                        print("\(tsDate)");
                        let tsDouble = tsDate.timeIntervalSince1970;
                        //                        print("\(tsDouble)");
                        
                    }
                    data.append(Profile(json: document.data()));
                }
                callback(data);
            }
        };
    }
    
    func getAllLikes(since:Int64, callback: @escaping ([Like]?)->Void){//TODO
        let db = Firestore.firestore()
        
        db.collection("likes").order(by: "lastUpdate").start(at: [Timestamp(seconds: since, nanoseconds: 1)]).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                callback(nil);
            } else {
                var data = [Like]();
                for document in querySnapshot!.documents {
                    if let ts = document.data()["lastUpdate"] as? Timestamp{
                        let tsDate = ts.dateValue();
                        print("\(tsDate)");
                        let tsDouble = tsDate.timeIntervalSince1970;
                        print("\(tsDouble)");
                        
                    }
                    data.append(Like(json: document.data()));
                }
                callback(data);
            }
        };
    }
}
