//
//  ProfileShowViewController.swift
//  What'sYourLook?
//
//  Created by admin on 11/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

class ProfileShowViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    
    var data = [Post](){
        didSet {
            tableView.reloadData()
        }
    }
    
    var observer:Any?;
    var profileName:String = ""
    private var profile:Profile?
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var joinedAtDate: UILabel!
    @IBOutlet weak var numOfLikes: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutBtn.isHidden = true
        logoutBtn.layer.borderWidth = 1
        logoutBtn.layer.masksToBounds = false
        //        logoutBtn.layer.borderColor = UIColor.black.cgColor
        logoutBtn.layer.cornerRadius = logoutBtn.frame.height / 2
        logoutBtn.clipsToBounds = true
        img.layer.borderWidth = 1
        img.layer.masksToBounds = false
        img.layer.borderColor = UIColor.black.cgColor
        img.layer.cornerRadius = img.frame.height / 2
        img.clipsToBounds = true
        
        observer = ModelEvents.PostEditedNotification.observe{
            if self.profileName != ""{
                self.data = postsModel.postsInstance.getAllPostsForProfile(name: self.profileName)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if profileName == "" && postsModel.postsInstance.LoggedInUser() == ""{
            let loginVC = LoginViewController.factory()
            show(loginVC, sender: self)
        } else {
            if profileName == "" {
                profileName = postsModel.postsInstance.LoggedInUser()
                logoutBtn.isHidden = false
            } else{
                logoutBtn.isHidden = true
            }
            profile = postsModel.postsInstance.getProfileByName(name: profileName)
            userName.text = profileName
            joinedAtDate.text = profile?.craetedAtDate
            numOfLikes.text = String(profile?.likesCount ?? 0)
            if profile?.avatar != ""{
                img.kf.setImage(with: URL(string: profile!.avatar));
            }
            data = postsModel.postsInstance.getAllPostsForProfile(name: profileName)
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfilePost", for: indexPath) as! ProfileTableViewCell
        
        let pst = data[indexPath.row]
        
        cell.postText.text = pst.postText
        cell.date.text = pst.date
        if pst.imgUrl != ""{
            cell.img.kf.setImage(with: URL(string: pst.imgUrl));
        } else {
            cell.img.image = UIImage(named: "plant1")
        }
        
        if postsModel.postsInstance.LoggedInUser() == profileName {
            cell.editBtn.isHidden = false
            cell.delBtn.isHidden = false
            cell.delBtn.tag = indexPath.row
            cell.editBtn.tag = indexPath.row
            cell.delBtn.addTarget(self, action: #selector(delButtonClick(sender:)), for: .touchUpInside)
            cell.editBtn.addTarget(self, action: #selector(editButtonClick(sender:)), for: .touchUpInside)
        } else {
            cell.editBtn.isHidden = true
            cell.delBtn.isHidden = true
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    
    
    @objc func delButtonClick(sender: UIButton) {
        
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let pst = data[indexPath.row]
        pst.isDeleted = true
        postsModel.postsInstance.updatePost(post: pst)
        data.remove(at: indexPath.row)
        //        tableView.reloadData()
        //        self.tabBarController?.selectedIndex = 0
    }
    
    @objc func editButtonClick(sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let EditPostVc:NewPostViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NewPostViewController");
        EditPostVc.postToEdit = data[indexPath.row]
        EditPostVc.title = "Edit post"
        present(EditPostVc, animated: true, completion: nil);
    }
    @IBAction func logOut(_ sender: Any) {
        postsModel.postsInstance.logOut()
        profileName = ""
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func backFromEditPost(segue:UIStoryboardSegue){
        //        data = postsModel.postsInstance.getAllPostsForProfile(name: profileName)
        //        tableView.reloadData()
    }
}
