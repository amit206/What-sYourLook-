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
    
    var postModelSql:PostModelSql = PostModelSql()
    
    private init(){
        postModelSql.connect()
        for i in 0...3{
            let postText = "blablablablablablablablabalballblablabla \n        blablablablablablablablabalballblablabla" + String(i)
            let st = Post(id: String(i), postText: postText, imgUrl: postText, uId: "1")//TODO: ID
            add(post: st)
        }
    }

    func add(post:Post){
        postModelSql.add(post: post)
    }
    
    func addLike(postId:String){
        postModelSql.addLike(postId:postId)
    }
    func removeLike(postId:String){
        postModelSql.removeLike(postId:postId)
    }
    
    func getAllPosts()->[Post]{
        return postModelSql.getAllPosts()
    }
}
