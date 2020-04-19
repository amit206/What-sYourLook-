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
    
    func updatePost(post:Post){
        let db = Firestore.firestore()
        db.collection("posts").document(post.id).updateData([
            "PST_TEXT":post.postText,
            "IMG_URL":post.imgUrl,
            "lastUpdate":FieldValue.serverTimestamp(),
            "isDeleted":post.isDeleted
                    ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated!")
                ModelEvents.PostDataNotification.post()
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
            }
        }
    }
    
    func addUser(profile:Profile)->Void{
        let db = Firestore.firestore()
        let json = profile.toJson()
        db.collection("users").document(profile.userName).setData( json ) {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("User added")
                ModelEvents.PostDataNotification.post()
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
                    data.append(Post(json: document.data()));
                }
                callback(data);
            }
        };
    }
    
    func getAllProfiles(since:Int64, callback: @escaping ([Profile]?)->Void){
        let db = Firestore.firestore()
        
        db.collection("users").order(by: "lastUpdate").start(at: [Timestamp(seconds: since, nanoseconds: 0)]).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                callback(nil);
            } else {
                var data = [Profile]();
                for document in querySnapshot!.documents {
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
                    data.append(Like(json: document.data()));
                }
                callback(data);
            }
        };
    }
}
