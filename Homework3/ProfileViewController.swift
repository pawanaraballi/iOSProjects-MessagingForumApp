//
//  ProfileViewController.swift
//  Homework3
//
//  Created by student on 8/5/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import SDWebImage
import MBProgressHUD

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var currUser = FIRAuth.auth()?.currentUser
    var rootRef = FIRDatabase.database().reference()
    
    var clickedUser : User?

    @IBOutlet weak var displayPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var email: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserDetails()
    }
    

    
    func fetchUserDetails(){
        [MBProgressHUD .showHUDAddedTo(self.view, animated:true)]
        self.rootRef.child("users").child((currUser?.uid)!).observeEventType(.Value, withBlock: { (snapshot) -> Void in
            let userObj = snapshot
            let dp =  userObj.value!["displayPic"] as? String
            let firstName =  userObj.value!["firstName"] as! String
            let lastName =  userObj.value!["lastName"] as! String
            let email =  userObj.value!["email"] as! String
            self.clickedUser = User(firstName: firstName,lastName: lastName,email: email, displayPic: dp!, uid: userObj.key)
            [MBProgressHUD .hideHUDForView(self.view, animated:true)]
            //displayPic.image = clickedUser?.displayPic
            self.userName.text = (" \(self.clickedUser!.firstName) \(self.clickedUser!.lastName) ")
            self.email.text = self.clickedUser?.email
            if self.clickedUser?.displayPic != "" {
                let imageURL = NSURL(string: (self.clickedUser?.displayPic)!)
                if let url = imageURL {
                    self.displayPic.sd_setImageWithURL(url)
                }
            }
            
        }) {(error) in
            print(error.localizedDescription)
        }
    }

    @IBAction func changeImage(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            selectedImageFromPicker = editedImage as? UIImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        dismissViewControllerAnimated(true, completion: nil)
        let imageName = NSUUID().UUIDString
        let storageRef = FIRStorage.storage().reference().child("\(imageName).png")
        if let uploadData = UIImagePNGRepresentation(selectedImageFromPicker!) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error)
                    return
                } else {
                    let newImageURLVal = metadata?.downloadURL()?.absoluteString
                    let imageURL = NSURL(string: newImageURLVal!)
                    if let url = imageURL {
                        self.displayPic.sd_setImageWithURL(url)
                    }
                    self.rootRef.child("users").child(self.currUser!.uid).child("displayPic").setValue(newImageURLVal)
                }
            })
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
