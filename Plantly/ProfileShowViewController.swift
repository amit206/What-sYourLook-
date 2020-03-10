//
//  ProfileShowViewController.swift
//  What'sYourLook?
//
//  Created by admin on 11/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

class ProfileShowViewController: UIViewController {
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    
    var profile:Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = profile?.userName
        img.image = UIImage(named:"avatar")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
