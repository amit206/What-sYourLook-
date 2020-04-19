//
//  NewPostViewController.swift
//  What'sYourLook?
//
//  Created by admin on 07/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit
import Kingfisher

class NewPostViewController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    @IBOutlet weak var ImgV: UIImageView!
    @IBOutlet weak var pstText: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var uploadImgBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    var postToEdit:Post?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if postsModel.postsInstance.LoggedInUser() == ""{
            let loginVC = LoginViewController.factory()
            show(loginVC, sender: self)
        } else if let myPost = postToEdit{
            ImgV.kf.setImage(with: URL(string: myPost.imgUrl));
            pstText.text = myPost.postText
        } else {
            takePic()
        }
        activity.isHidden = true;
        uploadImgBtn.isEnabled = true
        saveBtn.isEnabled = true
    }
    
    @IBAction func choosePic(_ sender: UIButton) {
        takePic()
    }
    
    func takePic() {
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
    
    var selectedImage:UIImage?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage;
        self.ImgV.image = selectedImage;
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func save(_ sender: UIButton) {
        activity.isHidden = false;
        uploadImgBtn.isEnabled = false
        saveBtn.isEnabled = false
        if let image = selectedImage{
            postsModel.postsInstance.saveImage(image: image) { (url) in
                print("saved image url \(url)");
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss.SSS"
                let pst = Post(id: postsModel.postsInstance.LoggedInUser() + formatter.string(from: date), postText: self.pstText.text!, imgUrl: url, uName: postsModel.postsInstance.LoggedInUser())
                postsModel.postsInstance.addPost(post: pst);
                self.pstText.text = ""
                self.ImgV.image = nil
                self.tabBarController?.selectedIndex = 0
            }
        } else if let myPost = self.postToEdit{
            let pst = Post(id: myPost.id, postText: self.pstText.text!, imgUrl: myPost.imgUrl, uName: postsModel.postsInstance.LoggedInUser())
            postsModel.postsInstance.addPost(post: pst);
            self.pstText.text = ""
            self.ImgV.image = nil
//            self.navigationController?.popViewController(animated: true);
            
            performSegue(withIdentifier: "EditPostSegue", sender: self)
        }
    }
}
