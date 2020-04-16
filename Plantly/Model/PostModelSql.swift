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
//        sqlite3_exec(database, "drop TABLE  LIKES", nil, nil, &errormsg);//todo:delete me
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
        
        res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS LAST_UPADATE_DATE (NAME TEXT PRIMARY KEY, DATE DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
        
        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (2, 'Uname10:44:53.941');",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (21,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (22,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (23,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (24,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (25,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (26,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (27,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (28,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (288,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (276,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (2766,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (2333,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (244,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (255,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (266,0);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (262,0);",nil, nil,&errormsg)//TODO: delme
//
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (2,1);",nil, nil,&errormsg)//TODO: delme
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO LIKES(USR_ID , PST_ID ) VALUES (1,1);",nil, nil,&errormsg)//TODO: delme
        
        
//      res = sqlite3_exec(database,"INSERT OR REPLACE INTO USERS(USR_ID, NAME, AVATAR) VALUES (1, 'AMIT1', 'firstPhoto');",nil, nil,&errormsg)//TODO: delme
//
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO USERS(USR_ID, NAME, AVATAR) VALUES (2, 'AMIT2', 'secPhoto');",nil, nil,&errormsg)//TODO: delme
//
//        res = sqlite3_exec(database,"INSERT OR REPLACE INTO USERS(USR_ID, NAME, AVATAR) VALUES (3, 'AMIT3', 'theardPhoto');",nil, nil,&errormsg)//TODO: delme'
        
    }
    
    // the INSERT OR REPLACE is good for update by ID
    func add(post:Post){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO POSTS(PST_ID, USR_ID, PST_TEXT, IMG_URL, DATE) VALUES (?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let pstId = post.id.cString(using: .utf8)
            let uId = post.uId.cString(using: .utf8)
            let text = post.postText.cString(using: .utf8)
            let img = post.imgUrl.cString(using: .utf8)
            let pst_date = post.date.cString(using: .utf8)

            
            sqlite3_bind_text(sqlite3_stmt, 1, pstId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, uId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, text,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, img,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, pst_date,-1,nil);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
    }
    
    func getAllPosts()->[Post]{
        var sqlite3_stmt_post: OpaquePointer? = nil
        var data = [Post]()
        var curUsrLike = false
        if (sqlite3_prepare_v2(database,"SELECT posts.PST_ID, posts.USR_ID, posts.PST_TEXT, posts.IMG_URL, posts.DATE, COUNT( likes.pst_id ), (select count( * ) from likes where likes.pst_id = posts.pst_id and likes.usr_id = 2), users.NAME FROM posts LEFT JOIN likes ON likes.pst_id = posts.pst_id LEFT JOIN users ON users.USR_ID = posts.usr_id GROUP BY posts.PST_ID, users.NAME, posts.USR_ID, posts.PST_TEXT, posts.IMG_URL, posts.DATE;",-1,&sqlite3_stmt_post,nil)
            == SQLITE_OK){
            //            sqlite3_bind_text(sqlite3_stmt_post, 1, "2".cString(using: .utf8),-1,nil);//todo:really logged user id (not usrId because it's the post's uploader)
            while(sqlite3_step(sqlite3_stmt_post) == SQLITE_ROW){
                let pstId = String(cString:sqlite3_column_text(sqlite3_stmt_post,0)!)
                let usrId = String(cString:sqlite3_column_text(sqlite3_stmt_post,1)!)
                let pstText = String(cString:sqlite3_column_text(sqlite3_stmt_post,2)!)
                let img = String(cString:sqlite3_column_text(sqlite3_stmt_post,3)!)
                let pstDate = String(cString:sqlite3_column_text(sqlite3_stmt_post,4)!)
                print(pstDate)
                let likesNum = String(cString:sqlite3_column_text(sqlite3_stmt_post,5)!)
//                print(String(cString:sqlite3_column_text(sqlite3_stmt_post,6)!))
                if((String(cString:sqlite3_column_text(sqlite3_stmt_post,6)!))=="1"){
                    curUsrLike = true
                }else {
                    curUsrLike = false
                }
                
                let usrName = String(cString:sqlite3_column_text(sqlite3_stmt_post,7)!)
                data.append(Post(id: pstId, postText: pstText, imgUrl: img, date: pstDate, curuserlike: curUsrLike, likesCount: Int(likesNum) ?? 88, uname: usrName, uId:usrId, userAvatar: "Amit a,mfvdrvrd"))//todo:
            }
        }
        sqlite3_finalize(sqlite3_stmt_post)
        return data
    }
    
    func addLike(postId:String){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO Likes(PST_ID, USR_ID) VALUES (?,2);",-1, &sqlite3_stmt,nil) == SQLITE_OK){

            sqlite3_bind_text(sqlite3_stmt, 1, postId,-1,nil);
//            sqlite3_bind_text(sqlite3_stmt, 2, "2",-1,nil);

            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
    }
    
    func removeLike(postId:String){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"DELETE FROM likes where PST_ID = ? AND USR_ID =2;",-1, &sqlite3_stmt,nil) == SQLITE_OK){

            sqlite3_bind_text(sqlite3_stmt, 1, postId,-1,nil);
//            sqlite3_bind_text(sqlite3_stmt, 2, "2",-1,nil);

            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("row deleted succefully")
            }
        }
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
            sqlite3_bind_text(sqlite3_stmt, 1, name,-1,nil);

            if(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                date = Int64(sqlite3_column_int64(sqlite3_stmt,1))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return date
    }
}
