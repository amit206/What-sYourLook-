//
//  Like.swift
//  What'sYourLook?
//
//  Created by admin on 16/04/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
import Firebase

class Like{
    var postId:String = ""
    var usrId:String = ""
    var lastUpdate:Int64?
    var isDeleted:Bool = false
    
    init(postId:String,
         usrId:String,
         isDeleted:Bool
    ){
        self.postId = postId
        self.usrId = usrId
        self.isDeleted = isDeleted
    }
    
    init(json:[String:Any]){
        self.isDeleted = json["isDeleted"] as! Bool;
        self.usrId = json["USR_ID"] as! String;
        self.postId = json["PST_ID"] as! String;
        let ts = json["lastUpdate"] as! Timestamp
        self.lastUpdate = ts.seconds
        
     }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]();
        json["USR_ID"] = usrId
        json["PST_ID"] = postId
        json["isDeleted"] = isDeleted
        json["lastUpdate"] = FieldValue.serverTimestamp()
        return json;
    }
}

