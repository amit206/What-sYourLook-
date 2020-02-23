//
//  postModel.swift
//  Plantly
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
//        st.uname = "name " + String(i)
//        st.id = String(i)
        var postText = "blablablablablablablablabalballblablabla \n        blablablablablablablablabalballblablabla" + String(i)
        let st = Post(id: String(i), text: postText, imgUrl: postText)
////        print("jiiii" + String(i))
        add(post: st)
    }
}

var data = [Post]()

func add(post:Post){
    postModelSql.add(post: post)
}

func getAllPosts()->[Post]{
    return postModelSql.getAllPosts()
}
}
