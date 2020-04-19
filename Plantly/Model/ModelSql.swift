//
//  PostModelSql.swift
//  What'sYourLook?
//
//  Created by admin on 23/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import Foundation
import SQLite3

class PostModelSql{
    
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    var database: OpaquePointer? = nil
    
    init() {
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
        
//                sqlite3_exec(database, "drop TABLE  LIKES", nil, nil, &errormsg);//todo:delete me
//                sqlite3_exec(database, "drop TABLE  POSTS", nil, nil, &errormsg);//todo:delete me
//                sqlite3_exec(database, "drop TABLE USERS", nil, nil, &errormsg);//todo:delete me
        
        var res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS POSTS (PST_ID TEXT PRIMARY KEY, USR_ID TEXT, PST_TEXT TEXT, IMG_URL TEXT, DATE TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table posts");
            return
        }
        
        res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS USERS (USR_NAME TEXT PRIMARY KEY, PASSWORD TEXT, AVATAR TEXT, DATE TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table users");
            return
        }
        
        res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS LIKES (USR_ID TEXT, PST_ID TEXT, PRIMARY KEY (USR_ID, PST_ID))", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table likes");
            return
        }
        
        res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS LAST_UPADATE_DATE (NAME TEXT PRIMARY KEY, DATE DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
        
    }
    
    // the INSERT OR REPLACE is good for update by ID
    func addPost(post:Post){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO POSTS(PST_ID, USR_ID, PST_TEXT, IMG_URL, DATE) VALUES (?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let pstId = post.id.cString(using: .utf8)
            let uId = post.uName.cString(using: .utf8)
            let text = post.postText.cString(using: .utf8)
            let img = post.imgUrl.cString(using: .utf8)
            let pst_date = post.date.cString(using: .utf8)
            
            
            sqlite3_bind_text(sqlite3_stmt, 1, pstId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, uId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, text,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, img,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, pst_date,-1,nil);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("POST " + post.postText + " added succefully")
            }
        }
    }
    
    func removePost(postId:String){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"DELETE FROM posts where PST_ID = ?;",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            sqlite3_bind_text(sqlite3_stmt, 1, postId,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("row deleted succefully")
            }
        }
    }
    
    func getAllPosts()->[Post]{
        var sqlite3_stmt_post: OpaquePointer? = nil
        var data = [Post]()
        var curUsrLike = false
        if (sqlite3_prepare_v2(database,"SELECT posts.PST_ID, posts.USR_ID, posts.PST_TEXT, posts.IMG_URL, posts.DATE, COUNT( likes.pst_id ), (select count( * ) from likes where likes.pst_id = posts.pst_id and likes.usr_id = ?), users.AVATAR FROM posts LEFT JOIN likes ON likes.pst_id = posts.pst_id LEFT JOIN users ON users.USR_NAME = posts.usr_id GROUP BY posts.PST_ID, users.USR_NAME, posts.USR_ID, posts.PST_TEXT, posts.IMG_URL, posts.DATE;",-1,&sqlite3_stmt_post,nil)
            == SQLITE_OK){
            sqlite3_bind_text(sqlite3_stmt_post, 1, postsModel.postsInstance.LoggedInUser().cString(using: .utf8),-1,SQLITE_TRANSIENT);
            while(sqlite3_step(sqlite3_stmt_post) == SQLITE_ROW){
                let pstId = String(cString:sqlite3_column_text(sqlite3_stmt_post,0)!)
                let usrName = String(cString:sqlite3_column_text(sqlite3_stmt_post,1)!)
                let pstText = String(cString:sqlite3_column_text(sqlite3_stmt_post,2)!)
                let img = String(cString:sqlite3_column_text(sqlite3_stmt_post,3)!)
                let pstDate = String(cString:sqlite3_column_text(sqlite3_stmt_post,4)!)
                //                print(pstDate)
                let likesNum = String(cString:sqlite3_column_text(sqlite3_stmt_post,5)!)
                //                print(String(cString:sqlite3_column_text(sqlite3_stmt_post,6)!))
                if((String(cString:sqlite3_column_text(sqlite3_stmt_post,6)!))=="1"){
                    curUsrLike = true
                }else {
                    curUsrLike = false
                }
                
                let usrAvatar = String(cString:sqlite3_column_text(sqlite3_stmt_post,7)!)
                data.append(Post(id: pstId, postText: pstText, imgUrl: img, date: pstDate, curuserlike: curUsrLike, likesCount: Int(likesNum) ?? 0 , uName: usrName, userAvatar: usrAvatar))
            }
        }
        sqlite3_finalize(sqlite3_stmt_post)
        return data
    }
    
    func addLike(like:Like){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO Likes(PST_ID, USR_ID) VALUES (?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            sqlite3_bind_text(sqlite3_stmt, 1, like.postId,-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlite3_stmt, 2, like.usrId,-1,SQLITE_TRANSIENT);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new LIKE added succefully")
            }
        }
    }
    
    func removeLike(like:Like){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"DELETE FROM likes where PST_ID = ? AND USR_ID = ?;",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            sqlite3_bind_text(sqlite3_stmt, 1, like.postId,-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlite3_stmt, 2, like.usrId,-1,SQLITE_TRANSIENT);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("row deleted succefully")
            }
        }
    }
    
    
    func addProfile(profile:Profile){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO USERS(USR_NAME, PASSWORD, AVATAR, DATE ) VALUES (?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            sqlite3_bind_text(sqlite3_stmt, 1, profile.userName,-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlite3_stmt, 2, profile.password,-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlite3_stmt, 3, profile.avatar,-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlite3_stmt, 4, profile.craetedAtDate,-1,SQLITE_TRANSIENT);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new PROFILE added succefully")
                
            }
        }
    }
    
    func getProfile(name:String)->Profile?{
        var sqlite3_stmt_profile: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT users.AVATAR, users.DATE, sum (( select count( * ) from likes where likes.pst_id = posts.pst_id )) FROM USERS LEFT JOIN posts ON users.USR_NAME = posts.usr_id WHERE USR_NAME = ? group by users.AVATAR, users.DATE;",-1,&sqlite3_stmt_profile,nil)
            == SQLITE_OK){
            
            sqlite3_bind_text(sqlite3_stmt_profile, 1, name,-1,SQLITE_TRANSIENT);
            
            while(sqlite3_step(sqlite3_stmt_profile) == SQLITE_ROW){
                
                let avatar = String(cString:sqlite3_column_text(sqlite3_stmt_profile,0)!)
                let date = String(cString:sqlite3_column_text(sqlite3_stmt_profile,1)!)
                let likesCount = Int(String(cString:sqlite3_column_text(sqlite3_stmt_profile,2)!))
                sqlite3_finalize(sqlite3_stmt_profile)
                return Profile(userName: name, likesCount: likesCount ?? 0, avatar: avatar, date: date)
            }
        }
        sqlite3_finalize(sqlite3_stmt_profile)
        return nil
    }
    
    func getAllPostsForProfile(name:String)->[Post]{
        var sqlite3_stmt_post: OpaquePointer? = nil
        var data = [Post]()
        if (sqlite3_prepare_v2(database,"SELECT PST_ID, PST_TEXT, IMG_URL, DATE FROM posts WHERE USR_ID = ?;",-1,&sqlite3_stmt_post,nil)
            == SQLITE_OK){
                        sqlite3_bind_text(sqlite3_stmt_post, 1, name,-1,SQLITE_TRANSIENT);
            
            while(sqlite3_step(sqlite3_stmt_post) == SQLITE_ROW){
                let pstId = String(cString:sqlite3_column_text(sqlite3_stmt_post,0)!)
                let pstText = String(cString:sqlite3_column_text(sqlite3_stmt_post,1)!)
                let img = String(cString:sqlite3_column_text(sqlite3_stmt_post,2)!)
                let pstDate = String(cString:sqlite3_column_text(sqlite3_stmt_post,3)!)
                
                
                data.append(Post(id: pstId, postText: pstText, imgUrl: img, date: pstDate))
            }
        }
        sqlite3_finalize(sqlite3_stmt_post)
        return data
    }
    
    func loginProfile(name:String, pass:String)->Bool{
        var sqlite3_stmt_profile: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT USR_NAME FROM USERS  WHERE USR_NAME = ? and password =?;",-1,&sqlite3_stmt_profile,nil)
            == SQLITE_OK){
            
            sqlite3_bind_text(sqlite3_stmt_profile, 1, name,-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlite3_stmt_profile, 2, pass,-1,SQLITE_TRANSIENT);
            
            if(sqlite3_step(sqlite3_stmt_profile) == SQLITE_ROW){
                print( String(cString:sqlite3_column_text(sqlite3_stmt_profile,0)!))
                sqlite3_finalize(sqlite3_stmt_profile)
                return true
            } else {
                sqlite3_finalize(sqlite3_stmt_profile)
                return false
            }
        }
        sqlite3_finalize(sqlite3_stmt_profile)
        return false
    }
    
    func setLastUpdate(name:String, lastUpdated:Int64){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO LAST_UPADATE_DATE( NAME, DATE) VALUES (?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            sqlite3_bind_text(sqlite3_stmt, 1, name,-1,nil);
            sqlite3_bind_int64(sqlite3_stmt, 2, lastUpdated);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    func getLastUpdateDate(name:String)->Int64{
        var date:Int64 = 0;
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from LAST_UPADATE_DATE where NAME like ?;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            sqlite3_bind_text(sqlite3_stmt, 1, name,-1,SQLITE_TRANSIENT);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                date = Int64(sqlite3_column_int64(sqlite3_stmt,1))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return date
    }
}
