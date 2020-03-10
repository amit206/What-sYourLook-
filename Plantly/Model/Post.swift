//
//  Post.swift
//  Plantly
//
//  Created by admin on 10/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation

class Post {
    
    var id:String = ""
    var imgUrl:String = ""
    var postText:String = ""
    var date:String?
    var curuserlike:Bool?
    var commentsCount:Int?
    var likesCount:Int
    var uName:String?
    var uId:String = ""
    var userAvatar:String?
    
    init(id:String,
         postText:String,
         imgUrl:String,
         date:String,
         curuserlike:Bool,
         commentsCount:Int,
         likesCount:Int,
         uname:String,
         uId:String,
         userAvatar:String
         ){
        self.id = id
        self.postText = postText
        self.imgUrl = imgUrl
        self.date = date
        self.curuserlike = curuserlike
        self.commentsCount = commentsCount
        self.likesCount = likesCount
        self.uName = uname
        self.uId = uId
        self.userAvatar = userAvatar
    }
    
        init(id:String,
             postText:String,
             imgUrl:String,
             uId:String
             ){
            self.id = id
            self.postText = postText
            self.imgUrl = imgUrl
    //        self.date = date
            self.curuserlike = false
            self.commentsCount = 0
            self.likesCount = 0
            self.uId = uId
//            self.uName = uname
        }
}
