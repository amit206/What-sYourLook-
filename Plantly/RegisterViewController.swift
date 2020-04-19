//
//  RegisterViewController.swift
//  What'sYourLook?
//
//  Created by admin on 18/04/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var selectedImage:UIImage?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activity.isHidden = true;
        userName.isEnabled = true
        Password.isEnabled = true
    }
    
    @IBAction func uploadImg(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage;
        self.avatar.image = selectedImage;
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func register(_ sender: UIButton) {
        if userName.text != ""{
            activity.isHidden = false;
            userName.isEnabled = false
            Password.isEnabled = false
            if let image = selectedImage{
                postsModel.postsInstance.saveImage(image: image) { (url) in
                    print(self.userName.text!);
                    postsModel.postsInstance.register(profile: Profile(userName: self.userName.text!, password: self.Password.text!, avatar: url))
                    self.userName.text = ""
                    self.Password.text = ""
                    self.navigationController?.popViewController(animated: true);
                }
            }
        }
    }
}
