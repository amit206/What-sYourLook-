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
    var profileName:String = ""
    private var profile:Profile?
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var joinedAtDate: UILabel!
    @IBOutlet weak var numOfLikes: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img.layer.borderWidth = 1
        img.layer.masksToBounds = false
        img.layer.borderColor = UIColor.black.cgColor
        img.layer.cornerRadius = img.frame.height / 2
        img.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if profileName == "" && postsModel.postsInstance.LoggedInUser() == ""{
            let loginVC = LoginViewController.factory()
            show(loginVC, sender: self)
        } else {
            if profileName == "" {
                profileName = postsModel.postsInstance.LoggedInUser()
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
        //            if(sender.tintColor == UIColor.red){
        //                data[sender.tag].curuserlike = false
        //                data[sender.tag].likesCount = data[sender.tag].likesCount - 1
        sender.tintColor = nil
        //                postsModel.postsInstance.removeLikeCurUser(postId: String(data[sender.tag].id))
        //            } else {
        //                data[sender.tag].curuserlike = true
        //                data[sender.tag].likesCount = data[sender.tag].likesCount + 1
        //                sender.tintColor = UIColor.red
        //                postsModel.postsInstance.addLikeCurUser(postId: String(data[sender.tag].id))
        //            }
        //            self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}
