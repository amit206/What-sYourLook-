//
//  PostModelSql.swift
//  What'sYourLook?
//
//  Created by admin on 23/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation

class PostModelSql{
    
    var database: OpaquePointer? = nil
    
    func connect() {
        let dbFileName = "database2.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
        }
        create()
    }
    
    func create(){
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        sqlite3_exec(database, "drop TABLE  POSTS", nil, nil, &errormsg);//todo:delete me AND CHANGE DATE
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS POSTS (PST_ID TEXT PRIMARY KEY, IMG_URL TEXT, LIKES_NUM INTEGER, DATE TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    // the INSERT OR REPLACE is good for update by ID
    func add(post:Post){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO POSTS(PST_ID, PST_TEXT, IMG) VALUES (?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id = post.id.cString(using: .utf8)
            let text = post.postText.cString(using: .utf8)
            let img = post.imgUrl.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, text,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, img,-1,nil);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
    }
    
    func getAllPosts()->[Post]{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Post]()
        
        if (sqlite3_prepare_v2(database,"SELECT * from POSTS;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let pstId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let text = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let img = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                
                data.append(Post(id:pstId, text:text, imgUrl:img))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
}
var uname:String?//need UId
var curuserlike:Bool?
