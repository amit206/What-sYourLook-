//
//  Profile.swift
//  What'sYourLook?
//
//  Created by admin on 11/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
import Firebase

class Profile{

    var userName:String = ""
    var password:String = ""
    var likesCount:Int = 0
    var avatar:String = ""
    var craetedAtDate:String = ""
    var lastUpdate:Int64?
    
    init(){
        //TODO:
    }
    
    init(json:[String:Any]){
        self.userName = json["USR_NAME"] as! String;
        self.password = json["PASSWORD"] as! String;
        self.avatar = json["avatar"] as! String;
        let ts = json["lastUpdate"] as! Timestamp
        self.lastUpdate = ts.seconds
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.craetedAtDate = formatter.string(from: ts.dateValue())
     }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]();
        json["USR_NAME"] = userName
        json["PASSWORD"] = password
        json["avatar"] = avatar
        json["lastUpdate"] = FieldValue.serverTimestamp()
        return json;
    }
}
