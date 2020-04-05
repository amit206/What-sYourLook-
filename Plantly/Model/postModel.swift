//
//  postModel.swift
//  What'sYourLook?
//
//  Created by admin on 10/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
class postsModel {
    
    static let postsInstance = postsModel()
    
//    var postModelSql:PostModelSql = PostModelSql()
    var modelFirebase:ModelFirebase = ModelFirebase()
    
    private init(){
//        postModelSql.connect()
//        for i in 0...5{
//            let postText = "blablablablablablablablabalballblablabla \n        blablablablablablablablabalballblablabla" + String(i)
//            let st = Post(id: String(i), postText: postText, imgUrl: postText, uId: "2")//TODO: ID
//            add(post: st)
//        }
    }

    func add(post:Post){
        modelFirebase.add(post: post)
    }
    
    func addLike(postId:String){
        modelFirebase.addLike(postId:postId)
    }
    func removeLike(postId:String){
        modelFirebase.removeLike(postId:postId)
    }
    
    func getAllPosts()->[Post]{
        return modelFirebase.getAllPosts()
    }
}
