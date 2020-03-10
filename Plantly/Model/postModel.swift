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
        let postText = "blablablablablablablablabalballblablabla \n        blablablablablablablablabalballblablabla" + String(i)
//        let st = Post(id: String(i), postText: postText, imgUrl: postText)
//        let st = Post(id: String(i), postText: pstText, imgUrl: postText/*, date: pstDate*/, curuserlike: true, commentsCount: 0, likesCount: Int(likesNum) ?? 888, uname: usrId, userAvatar: "Amit a,mfvdrvrd")
        let st = Post(id: String(i), postText: postText, imgUrl: postText, uId: "1")//TODO: ID
        add(post: st)
//        add(post: st)
//        data.append()//todo:
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
