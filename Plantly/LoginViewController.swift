//
//  LoginViewController.swift
//  What'sYourLook?
//
//  Created by admin on 18/04/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorMsg: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorMsg.isHidden = true
        
        // hook to the nav back button
        self.navigationItem.hidesBackButton = true
        let newBackBtn = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if postsModel.postsInstance.LoggedInUser() != ""{
            self.navigationController?.popViewController(animated: true);
        }
    }
    
    static func factory()->LoginViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController");
    }
    
    @objc func back(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "cancelLoginSegue", sender: self)
    }
    
    @IBAction func login(_ sender: UIButton) {
        if !postsModel.postsInstance.logIn(userName: userName.text!, pwd: password.text! ){
            errorMsg.isHidden = false
        } else {
            errorMsg.isHidden = true
            self.navigationController?.popViewController(animated: true);
        }
    }
}
