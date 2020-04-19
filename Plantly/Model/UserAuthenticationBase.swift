//
//  UserAuthenticationBase.swift
//  What'sYourLook?
//
//  Created by admin on 18/04/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation

extension postsModel {
    
    
    func LoggedInUser()->String{
        
        return self.logedInUser
    }
    
    func logIn(userName:String, pwd:String)->Bool{
        if modelSql.loginProfile(name: userName, pass: pwd){
            self.logedInUser = userName;
            return true
        } else {
            return false
        }
    }
    
    func logOut(){
        self.logedInUser = "";
    }
    
    func register(user:String, email:String, pwd:String, callback:(Bool)->Void){
        self.logedInUser = user;
        callback(true);
    }
}
