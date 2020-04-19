//
//  PostsTableViewController.swift
//  What'sYourLook?
//
//  Created by admin on 10/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit
import Kingfisher

class PostsTableViewController: UITableViewController {
    
    var data = [Post]()
    var observer:Any?;
    
//    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        observer = ModelEvents.PostDataNotification.observe{
            self.reloadData();
        }
        
        self.refreshControl?.beginRefreshing()
        reloadData();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    deinit{
        if let observer = observer{
            ModelEvents.removeObserver(observer: observer)
        }
    }
    
    @objc func reloadData(){
        postsModel.postsInstance.getAllPosts{ (_data:[Post]?) in
            if (_data != nil) {
                self.data = _data!;
                self.tableView.reloadData();
            }
            self.refreshControl?.endRefreshing()
        };
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    var rowSelected:Int = 0
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PostViewCell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostViewCell
        
        //Configure the cell...
        let pst = data[indexPath.row]
        cell.userName.text = pst.uName
        cell.postText.text = pst.postText
        if pst.imgUrl != ""{
            cell.img.kf.setImage(with: URL(string: pst.imgUrl));
        } else {
            cell.img.image = UIImage(named: "plant1")
        }
        if pst.userAvatar != ""{
            cell.avatar.kf.setImage(with: URL(string: pst.userAvatar!));
        } else {
            cell.avatar.image = UIImage(named: "avatar")
        }
        cell.likes_num.text = String(pst.likesCount)
        cell.date.text = pst.date
        if (pst.curuserlike == true){
            cell.like.tintColor = UIColor.red
        } else {
            cell.like.tintColor = nil
        }
        cell.like.tag = indexPath.row
        
        cell.like.addTarget(self, action: #selector(didButtonClick(sender:)), for: .touchUpInside)
        return cell
    }
    
    
    @objc func didButtonClick(sender: UIButton) {
        if postsModel.postsInstance.LoggedInUser() == "" {
            let loginVC = LoginViewController.factory()
            show(loginVC, sender: self)
        } else {
            let indexPath = IndexPath(item: sender.tag, section: 0)
            if(sender.tintColor == UIColor.red){
                data[sender.tag].curuserlike = false
                data[sender.tag].likesCount = data[sender.tag].likesCount - 1
                sender.tintColor = UIColor.lightGray
                postsModel.postsInstance.removeLikeCurUser(postId: String(data[sender.tag].id))
            } else {
                data[sender.tag].curuserlike = true
                data[sender.tag].likesCount = data[sender.tag].likesCount + 1
                sender.tintColor = UIColor.red
                postsModel.postsInstance.addLikeCurUser(postId: String(data[sender.tag].id))
            }
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let secondVc:ProfileShowViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileViewController");
        secondVc.profileName = data[indexPath.row].uName
        present(secondVc, animated: true, completion: nil);
        
        
    }
    
    @IBAction func backFromCancelLogin(segue:UIStoryboardSegue){
        
    }
    
}
