//
//  EventNotificationsBase.swift
//  What'sYourLook?
//
//  Created by admin on 02/04/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation

class ModelEvents{
    static let PostDataNotification = ModelEventsTemplate(name: "WhatsYourLook.PostDataNotification");
    //    static let LoginStateNotification = ModelEventsTemplate(name: "com.menachi.LoginStateNotification");
    
    
    static func removeObserver(observer:Any){
        NotificationCenter.default.removeObserver(observer)
    }
    
    private init(){}
}

class ModelEventsTemplate{
    let notificationName:String;
    
    init(name:String){
        notificationName = name;
    }
    func observe(callback:@escaping ()->Void)->Any{
        return NotificationCenter.default.addObserver(forName: NSNotification.Name(notificationName),
                                                      object: nil, queue: nil) {
                                                        (data) in callback();
        }
    }
    
    func post(){
        NotificationCenter.default.post(name: NSNotification.Name(notificationName), object: self,userInfo:nil);
    }
    
    
}
