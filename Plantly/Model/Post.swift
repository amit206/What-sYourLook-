//
//  Post.swift
//  What'sYourLook?
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
    var likesCount:Int
    var uName:String?
    var uId:String = ""
    var userAvatar:String?
    
    init(id:String,
         postText:String,
         imgUrl:String,
         date:String,
         curuserlike:Bool,
//         commentsCount:Int,
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
//        self.commentsCount = commentsCount
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
//            self.commentsCount = 0
            self.likesCount = 0
            self.uId = uId
//            self.uName = uname
        }
    
    init(json:[String:Any]){
        self.id = json["PST_ID"] as! String;
        self.uId = json["USR_ID"] as! String;
        self.postText = json["PST_TEXT"] as! String;
        self.imgUrl = json["IMG_URL"] as! String;
        self.curuserlike = true;//json["IMG_URL"] as? Bool;
        self.likesCount = 999;//json["IMG_URL"] as! Int;

    }
    
    func toJson() -> [String:String] {
        var json = [String:String]();
        json["PST_ID"] = id
        json["PST_TEXT"] = postText
        json["USR_ID"] = uId
        json["IMG_URL"] = imgUrl
        return json;
    }
}
