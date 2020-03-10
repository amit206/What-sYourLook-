//
//  PostsTableViewController.swift
//  Plantly
//
//  Created by admin on 10/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {

    var data = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = postsModel.postsInstance.getAllPosts()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

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
        cell.img.image = UIImage(named: "plant1")
        cell.avatar.image = UIImage(named: "avatar")
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
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
////        let cell = self.tableView.cellForRow(at: indexPath as IndexPath)
//        self.rowSelected = indexPath.row
//        print("hi: " + String(rowSelected))
//        print(data[rowSelected].uname!)
//        data[rowSelected].curuserlike = true
//        print(data[rowSelected].curuserlike)
//        tableView.reloadData()
//    }
    @objc func didButtonClick(sender: UIButton) {
        // your code goes here
        print(sender.tag)
        if(sender.tintColor == UIColor.red){
            data[sender.tag].curuserlike = false
            sender.tintColor = nil
        } else {
            data[sender.tag].curuserlike = true
            sender.tintColor = UIColor.red
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "ShowProfileSegue"){
                let vc:ProfileShowViewController = segue.destination as! ProfileShowViewController
                vc.profile = selected
            }
        }
        
        var selected:Profile?
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //selected = data[indexPath.row]
            selected = Profile()
            selected?.userName = data[indexPath.row].uName
            performSegue(withIdentifier: "ShowProfileSegue", sender: self)
        }

    }
