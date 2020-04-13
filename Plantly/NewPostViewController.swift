//
//  NewPostViewController.swift
//  What'sYourLook?
//
//  Created by admin on 07/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var pstText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takePic()
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
        self.avatar.image = selectedImage;
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func save(_ sender: UIButton) {
        if let image = selectedImage{
            //            postsModel.instance.saveImage(image: image) { (url) in               print("saved image url \(url)");
            let pst = Post(id: "546", postText: self.pstText.text!, imgUrl: self.pstText.text!, uId: "2")
            

            postsModel.postsInstance.addPost(post: pst);

            //            }
        }
    }
    
}
