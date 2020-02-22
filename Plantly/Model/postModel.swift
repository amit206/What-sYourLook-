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

private init(){
    for i in 0...3{
        let st = Post()
        st.uname = "name " + String(i)
        st.id = String(i)
        st.postText = "blablablablablablablablabalballblablabla \n        blablablablablablablablabalballblablabla" + String(i)
//        print("jiiii" + String(i))
        add(post: st)
    }
}

var data = [Post]()

func add(post:Post){
    data.append(post)
}

func getAllPosts()->[Post]{
    return data
}
}
