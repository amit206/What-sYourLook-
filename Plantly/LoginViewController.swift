//
//  LoginViewController.swift
//  What'sYourLook?
//
//  Created by admin on 18/04/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

//protocol LoginViewControllerDelegate {
//    func onLoginSuccess();
//    func onLoginCancell();
//}

class LoginViewController: UIViewController {
//    var delegate:LoginViewControllerDelegate?

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
//    static func factory()->LoginViewController{
//        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController")
//    }
    //    @objc func back(sender: UIBarButtonItem) {
    //        //        performSegue(withIdentifier: "cancelLoginSegue", sender: self)
    //        self.navigationController?.popViewController(animated: true);
    //
    //        if let delegate = delegate{
    //            delegate.onLoginCancell()
    //        }
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // hook to the nav back button
        self.navigationItem.hidesBackButton = true
        let newBackBtn = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackBtn
    }
    
    static func factory()->LoginViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController");
    }
    
        @objc func back(sender: UIBarButtonItem) {
            performSegue(withIdentifier: "cancelLoginSegue", sender: self)
    }
    
    @IBAction func login(_ sender: UIButton) {
        postsModel.postsInstance.logIn(userName: userName.text!, pwd: password.text! ){ (success) in
            if (success){
                self.navigationController?.popViewController(animated: true);

                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//}
