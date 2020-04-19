//
//  Post.swift
//  What'sYourLook?
//
//  Created by admin on 10/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    var id:String = ""
    var imgUrl:String = ""
    var postText:String = ""
    var date:String = ""
    var curuserlike:Bool?
    var likesCount:Int = 0
    var uName:String = ""
    var userAvatar:String?
    var lastUpdate:Int64?
    var isDeleted:Bool = false
    
    // post for main list
    init(id:String,
         postText:String,
         imgUrl:String,
         date:String,
         curuserlike:Bool,
         likesCount:Int,
         uName:String,
         userAvatar:String
    ){
        self.id = id
        self.postText = postText
        self.imgUrl = imgUrl
        self.date = date
        self.curuserlike = curuserlike
        self.likesCount = likesCount
        self.uName = uName
        self.userAvatar = userAvatar
    }
    
    // post creation
    init(id:String,
         postText:String,
         imgUrl:String,
         uName:String
    ){
        self.id = id
        self.postText = postText
        self.imgUrl = imgUrl
        self.curuserlike = false
        self.likesCount = 0
        self.uName = uName
    }
    
    // post for profile list
    init(id:String,
         postText:String,
         imgUrl:String,
         date:String
    ){
        self.id = id
        self.postText = postText
        self.imgUrl = imgUrl
        self.date = date
    }
    
    init(json:[String:Any]){
        self.isDeleted = json["isDeleted"] as! Bool;
        self.id = json["PST_ID"] as! String;
        self.uName = json["USR_ID"] as! String;
        self.postText = json["PST_TEXT"] as! String;
        self.imgUrl = json["IMG_URL"] as! String;
        self.curuserlike = true;//json["IMG_URL"] as? Bool;
        
        let ts = json["lastUpdate"] as! Timestamp
        self.lastUpdate = ts.seconds
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.date = formatter.string(from: ts.dateValue())
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]();
        json["PST_ID"] = id
        json["PST_TEXT"] = postText
        json["USR_ID"] = uName
        json["IMG_URL"] = imgUrl
        json["lastUpdate"] = FieldValue.serverTimestamp()
        json["isDeleted"] = isDeleted
        return json;
    }
}
