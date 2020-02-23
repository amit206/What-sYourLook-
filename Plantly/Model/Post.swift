//
//  Post.swift
//  Plantly
//
//  Created by admin on 10/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation

class Post {
    var uname:String?//need UId
    var id:String = ""
    var postText:String = ""
    var curuserlike:Bool?
    var imgUrl:String = ""
    
    init(id:String, text:String, imgUrl:String){
        self.id = id
        self.postText = text
        self.imgUrl = imgUrl
    }
}
