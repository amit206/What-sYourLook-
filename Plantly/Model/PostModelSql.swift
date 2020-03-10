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
        sqlite3_exec(database, "drop TABLE  LIKES", nil, nil, &errormsg);//todo:delete me
        sqlite3_exec(database, "drop TABLE  POSTS", nil, nil, &errormsg);//todo:delete me
        var res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS POSTS (PST_ID TEXT PRIMARY KEY, USR_ID TEXT, PST_TEXT TEXT, IMG_URL TEXT, DATE TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table posts");
            return
        }
        
        res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS USERS (USR_ID TEXT PRIMARY KEY, NAME TEXT, AVATAR TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table users");
            return
        }
        
        res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS LIKES (USR_ID TEXT, PST_ID TEXT, PRIMARY KEY (USR_ID, PST_ID))", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table likes");
            return
        }
        
        res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS COMMENTS (USR_ID TEXT, PST_ID TEXT, DATE TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table comments");
            return
        }
        
        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (2,0);",nil, nil,&errormsg)//TODO: delme
        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (2,1);",nil, nil,&errormsg)//TODO: delme
        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (1,1);",nil, nil,&errormsg)//TODO: delme
        
    }
    
    // the INSERT OR REPLACE is good for update by ID
    func add(post:Post){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO POSTS(PST_ID, USR_ID, PST_TEXT, IMG_URL, DATE) VALUES (?,?,?,?,DATE('NOW'));",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let pstId = post.id.cString(using: .utf8)
            let uId = post.uId.cString(using: .utf8)
            let text = post.postText.cString(using: .utf8)
            let img = post.imgUrl.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, pstId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, uId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, text,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, img,-1,nil);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        
        //        if(post.id == 1){
        //            res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID TEXT, PST_ID TEXT) VALUES (1,1);",nil, nil,&errormsg)
        //        }
    }
    
    func getAllPosts()->[Post]{
        var sqlite3_stmt_post: OpaquePointer? = nil
        var sqlite3_stmt_cur_user_like: OpaquePointer? = nil
        var data = [Post]()
        var curUsrLike = false
        if (sqlite3_prepare_v2(database,"SELECT posts.PST_ID, posts.USR_ID, posts.PST_TEXT, posts.IMG_URL, posts.DATE, COUNT( likes.pst_id ) FROM posts LEFT JOIN likes ON likes.pst_id = posts.pst_id GROUP BY posts.PST_ID, posts.USR_ID, posts.PST_TEXT, posts.IMG_URL, posts.DATE;",-1,&sqlite3_stmt_post,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt_post) == SQLITE_ROW){
                let pstId = String(cString:sqlite3_column_text(sqlite3_stmt_post,0)!)
                let usrId = String(cString:sqlite3_column_text(sqlite3_stmt_post,1)!)
                let pstText = String(cString:sqlite3_column_text(sqlite3_stmt_post,2)!)
                let img = String(cString:sqlite3_column_text(sqlite3_stmt_post,3)!)
                //                let pstDate = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                let likesNum = String(cString:sqlite3_column_text(sqlite3_stmt_post,5)!)
                
                curUsrLike = false
                
//                if (sqlite3_prepare_v2(database,"SELECT * FROM likes WHERE pst_id = ? AND usr_id = ?;",-1,&sqlite3_stmt_cur_user_like,nil)
//                    == SQLITE_OK){
                if (sqlite3_prepare_v2(database,"SELECT * FROM likes WHERE USR_ID = 2 AND PST_ID = ?;", -1, &sqlite3_stmt_cur_user_like,nil)
                == SQLITE_OK){
                    sqlite3_bind_text(sqlite3_stmt_cur_user_like, 1, pstId,-1,nil);
//                    sqlite3_bind_text(sqlite3_stmt_cur_user_like, 2, String(2),-1,nil);//todo:really logged user id (not usrId because it's the post's uploader)
                    
                    while(sqlite3_step(sqlite3_stmt_cur_user_like) == SQLITE_ROW){
                     print("look: " + pstId + " " +  String(cString:sqlite3_column_text(sqlite3_stmt_cur_user_like,0)!) + " " + String(cString:sqlite3_column_text(sqlite3_stmt_cur_user_like,1)!))
                    }
//                    if(sqlite3_step(sqlite3_stmt_cur_user_like) == SQLITE_ROW){
//                        print( "pst id: " + pstId )
//                        print(String(cString:sqlite3_column_text(sqlite3_stmt_cur_user_like,0)!))
//                        if(String(cString:sqlite3_column_text(sqlite3_stmt_cur_user_like,0)!)=="1"){
//                            curUsrLike = true
//                        }
//                    }
                }
                sqlite3_finalize(sqlite3_stmt_cur_user_like)
                
                data.append(Post(id: pstId, postText: pstText, imgUrl: img/*, date: pstDate*/, curuserlike: curUsrLike, commentsCount: 0, likesCount: Int(likesNum) ?? 88, uname: usrId, uId:usrId, userAvatar: "Amit a,mfvdrvrd"))//todo:
            }
        }
        sqlite3_finalize(sqlite3_stmt_post)
        return data
    }
}
var uname:String?//need UId
var curuserlike:Bool?
