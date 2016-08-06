//
//  MessageViewController.swift
//  Homework3
//
//  Created by student on 8/5/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage
import MBProgressHUD

class MessageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var message: UITextView!
    var currUser = FIRAuth.auth()?.currentUser
    var userRef = FIRDatabase.database().reference()
    
    var clickedUser : User?
    override func viewDidLoad() {
        super.viewDidLoad()

        userName.text = (" \(clickedUser!.firstName) \(clickedUser!.lastName) ")
        if clickedUser?.displayPic != "" {
            let imageURL = NSURL(string: (self.clickedUser?.displayPic)!)
            if let url = imageURL {
                self.imageView.sd_setImageWithURL(url)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButton(sender: UIBarButtonItem) {
        [MBProgressHUD .showHUDAddedTo(self.view, animated:true)]
        self.userRef.child("users").child((currUser?.uid)!).observeEventType(.Value, withBlock: { (snapshot) -> Void in
            let userObj = snapshot
            let dp =  userObj.value!["displayPic"] as? String
            let firstName =  userObj.value!["firstName"] as! String
            let lastName =  userObj.value!["lastName"] as! String
            let email =  userObj.value!["email"] as! String
            self.userRef.child("messages").childByAutoId().setValue(["sentID": self.currUser?.uid,"sentName": ("\(firstName) \(lastName)"), "DisplayPic": dp! ,"receiverID": self.clickedUser!.uid,"receiverName": ("\(self.clickedUser!.firstName) \(self.clickedUser!.lastName)"),"receiverdisplayPic": self.clickedUser!.displayPic,"message": self.message.text,"read": "false"])
            [MBProgressHUD .hideHUDForView(self.view, animated:true)]
            let alert = UIAlertView()
            alert.title = "Saved"
            alert.message = "Message Saved"
            alert.addButtonWithTitle("Understood")
            alert.show()
            self.dismissViewControllerAnimated(true, completion: nil)
        }) {(error) in
            print(error.localizedDescription)
        }

    }
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
