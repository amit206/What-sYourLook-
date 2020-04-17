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
        //        modelSql.setLastUpdate(name: "POSTS", lastUpdated: 1)
        //        modelSql.setLastUpdate(name: "LIKES", lastUpdated: 1)
        //        modelSql.setLastUpdate(name: "PROFILES", lastUpdated: 1)
    }
    
    func addPost(post:Post){
        modelFirebase.addPost(post: post)
    }
    
    func removePost(postId:String){
        modelFirebase.removePost(postId: postId)
    }
    
    func addLikeCurUser(postId:String){
        let like:Like = Like(postId: postId, usrId: "2", isDeleted: false)//TODO:
        self.modelSql.addLike(like: like)
        modelFirebase.updateLike(like: like)
    }
    func removeLikeCurUser(postId:String){
        let like:Like = Like(postId: postId, usrId: "2", isDeleted: true)//TODO:
        self.modelSql.removeLike(like: like)
        modelFirebase.updateLike(like: like)
    }
    
    func getAllPosts(callback:@escaping ([Post]?)->Void){
        //get the local last update dates
        let lastUDPost = modelSql.getLastUpdateDate(name: "POSTS");//Int64(1)//
        let lastUDLikes = modelSql.getLastUpdateDate(name: "LIKES");//Int64(1)//
        let lastUDProfile = modelSql.getLastUpdateDate(name: "PROFILES");//Int64(1)//
        
        
        //get the cloud updates since the local update date
        modelFirebase.getAllProfiles(since: lastUDProfile) { (usrData) in
            //insert update to the local db
            var ludProfile:Int64 = 0;
            for profile in usrData!{
                self.modelSql.addProfile(profile: profile)
                if profile.lastUpdate! > ludProfile {ludProfile = profile.lastUpdate!}
            }
            
            //update the students local last update date
            self.modelSql.setLastUpdate(name: "PROFILES", lastUpdated: ludProfile)
            
            //*************//
            self.modelFirebase.getAllLikes(since: lastUDLikes) { (likesData) in
                //insert update to the local db
                var ludLikes:Int64 = 0;
                for like in likesData!{
                    if like.isDeleted == true {
                        self.modelSql.removeLike(like: like)
                    } else {
                        self.modelSql.addLike(like: like)
                    }
                    
                    if like.lastUpdate! > ludLikes {ludLikes = like.lastUpdate!}
                }
                
                //update the students local last update date
                self.modelSql.setLastUpdate(name: "LIKES", lastUpdated: ludLikes)
                
                //*************//
                self.modelFirebase.getAllPosts(since:lastUDPost) { (data) in
                    //insert update to the local db
                    var ludPosts:Int64 = 0;
                    for post in data!{
                        if post.isDeleted == true {
                            self.modelSql.removePost(postId: post.id)
                        } else {
                            self.modelSql.addPost(post: post)
                        }
                        if post.lastUpdate! > ludPosts {ludPosts = post.lastUpdate!}
                    }
                    
                    //update the students local last update date
                    self.modelSql.setLastUpdate(name: "POSTS", lastUpdated: ludPosts)
                    
                    // get the complete student list
                    let finalData = self.modelSql.getAllPosts()
                    
                    callback(finalData);
                }
            }
        }
        
    }
    
    func saveImage(image:UIImage, callback: @escaping (String)->Void){
        FirebaseStorage.saveImage(image: image, callback: callback)
    }
    
    
    func getProfileByName(name:String)->Profile{
        return modelSql.getProfile(name: name)!
    }
}
//extension Date {
//    var millisecondsSince1970:Int64 {
//        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
//    }
//
//    init(milliseconds:Int64) {
//        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
//    }
//}
