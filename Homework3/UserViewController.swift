//
//  UserViewController.swift
//  Homework3
//
//  Created by student on 8/4/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import SDWebImage

class UserViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var currUser = FIRAuth.auth()?.currentUser
    var rootRef = FIRDatabase.database().reference()

    @IBOutlet weak var displayPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var changePic: UIButton!
    
    var clickedUser : User?
    override func viewDidLoad() {
        super.viewDidLoad()

        //displayPic.image = clickedUser?.displayPic
        userName.text = (" \(clickedUser!.firstName) \(clickedUser!.lastName) ")
        email.text = clickedUser?.email
        if clickedUser?.displayPic != "" {
            let imageURL = NSURL(string: (self.clickedUser?.displayPic)!)
            if let url = imageURL {
                self.displayPic.sd_setImageWithURL(url)
            }
        }
        if clickedUser?.uid == (currUser?.uid)! as String {
            self.changePic.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeDisplayPic(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
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
    
    



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "messageSegue":
            if let destination = segue.destinationViewController as? MessageViewController {
                destination.clickedUser = self.clickedUser
                
            }
        default:
            break
        }
    }
    

}


protocol updateFields {
    func sendMessage(user: User)
}
