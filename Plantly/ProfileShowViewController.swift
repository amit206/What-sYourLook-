//
//  ProfileShowViewController.swift
//  What'sYourLook?
//
//  Created by admin on 11/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

class ProfileShowViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    
    var data = [Post]()
    var profileName:String = ""
    private var profile:Profile?
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var joinedAtDate: UILabel!
    @IBOutlet weak var numOfLikes: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profile = postsModel.postsInstance.getProfileByName(name: profileName)
        userName.text = profileName
        joinedAtDate.text = profile?.craetedAtDate
        numOfLikes.text = String(profile?.likesCount ?? 0)
        if profile?.avatar != ""{
            img.kf.setImage(with: URL(string: profile!.avatar));
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfilePost", for: indexPath) as! ProfileTableViewCell
        
        cell.postText.text = "hello world"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3//data.count
    }
    
    
    
    @objc func didButtonClick(sender: UIButton) {
        //            let indexPath = IndexPath(item: sender.tag, section: 0)
        //            if(sender.tintColor == UIColor.red){
        //                data[sender.tag].curuserlike = false
        //                data[sender.tag].likesCount = data[sender.tag].likesCount - 1
        //                sender.tintColor = nil
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
