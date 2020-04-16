//
//  postModel.swift
//  What'sYourLook?
//
//  Created by admin on 10/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
import UIKit

class postsModel {
    
    static let postsInstance = postsModel()
    
    var modelFirebase:ModelFirebase = ModelFirebase()
    var modelSql:PostModelSql = PostModelSql()
    
    private init(){
        modelSql.setLastUpdate(name: "POSTS", lastUpdated: 1)
    }

    func addPost(post:Post){
        modelFirebase.addPost(post: post)
    }
    
    func removePost(postId:String){
        modelFirebase.removePost(postId: postId)
    }
    
    func addLike(postId:String){
        modelFirebase.addLike(postId:postId)
    }
    func removeLike(postId:String){
        modelFirebase.removeLike(postId:postId)
    }
    
    func getAllPosts(callback:@escaping ([Post]?)->Void){
        //get the local last update date
        let lud = modelSql.getLastUpdateDate(name: "POSTS");
        
        //get the cloud updates since the local update date
        modelFirebase.getAllPosts(since:lud) { (data) in
            //insert update to the local db
            var lud:Int64 = 0;
            for post in data!{
                self.modelSql.add(post: post)
                if post.lastUpdate! > lud {lud = post.lastUpdate!}
            }
            
            //update the students local last update date
            self.modelSql.setLastUpdate(name: "POSTS", lastUpdated: lud)
            
            // get the complete student list
            let finalData = self.modelSql.getAllPosts()
            callback(finalData);
        }
//        return modelFirebase.getAllPosts(callback: callback);
    }
    
    func saveImage(image:UIImage, callback: @escaping (String)->Void){
         FirebaseStorage.saveImage(image: image, callback: callback)
     }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
