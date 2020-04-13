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
    
//    var postModelSql:PostModelSql = PostModelSql()
    var modelFirebase:ModelFirebase = ModelFirebase()
    
    private init(){
//        postModelSql.connect()
//        for i in 0...0{
//            let postText = "blablablablablablablablabalballblablabla \n        blablablablablablablablabalballblablabla" + String(i)
//            let st = Post(id: String(i), postText: postText, imgUrl: postText, uId: "2")//TODO: ID
//            addPost(post: st)
//        }
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
        return modelFirebase.getAllPosts(callback: callback);
    }
    
    func saveImage(image:UIImage, callback: @escaping (String)->Void){
         FirebaseStorage.saveImage(image: image, callback: callback)
     }
}
