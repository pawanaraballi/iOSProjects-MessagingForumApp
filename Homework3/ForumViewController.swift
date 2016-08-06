//
//  ForumViewController.swift
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
import MGSwipeTableCell

class ForumViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    var currUser = FIRAuth.auth()?.currentUser
    var rootRef = FIRDatabase.database().reference()
    
    var clickedForum : ForumPosts?
    var clickedUser : User?
    var newImageURLVal = ""
    var comments = [Comments]()
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var forumImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var writeComment: UITextField!
    @IBOutlet weak var currentUserImage: UIImageView!
    @IBOutlet weak var uploadedImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comments"
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
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
            if self.clickedUser?.displayPic != "" {
                let imageURL = NSURL(string: (self.clickedUser?.displayPic)!)
                if let url = imageURL {
                    self.currentUserImage.sd_setImageWithURL(url)
                }
            }
            
        }) {(error) in
            print(error.localizedDescription)
        }
        
        let imageURL = NSURL(string: (clickedForum?.displayPic)!)
        if let url = imageURL {
            forumImage.sd_setImageWithURL(url)
        }
        userName.text = clickedForum?.postedBy
        message.text = clickedForum?.message
        
        fetchComments()
    }
    
    func fetchComments(){
        [MBProgressHUD .showHUDAddedTo(self.view, animated:true)]
        var commentRef = self.rootRef.child("forums").child("\(self.clickedForum!.uid)")
        commentRef.child("comments").observeEventType(.Value, withBlock: { (snapshot) -> Void in
            self.comments.removeAll()
            let enumerator = snapshot.children
            while let message = enumerator.nextObject() as? FIRDataSnapshot {
                let uid = message.key
                let displayPic = message.value!["displayPic"] as? String
                let commentImage = message.value!["commentPic"] as? String
                let postedID = message.value!["postedID"] as? String
                let postedBy = message.value!["postedBy"] as? String
                let message = message.value!["message"] as? String
                let userObj = Comments(postedBy: postedBy!,postedID: postedID!,message: message!, displayPic: displayPic!,commentImage: commentImage!,uid: uid)
                self.comments.append(userObj)
                
            }
            [MBProgressHUD .hideHUDForView(self.view, animated:true)]
            print(self.comments.count)
            self.tableView.reloadData()
        }) {(error) in
            print(error.localizedDescription)
        }
        [MBProgressHUD .hideHUDForView(self.view, animated:true)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func postComment(sender: UIButton) {
        [MBProgressHUD .showHUDAddedTo(self.view, animated:true)]
        self.rootRef.child("users").child((currUser?.uid)!).observeEventType(.Value, withBlock: { (snapshot) -> Void in
        let userObj = snapshot
        let dp =  userObj.value!["displayPic"] as? String
        let firstName =  userObj.value!["firstName"] as! String
        let lastName =  userObj.value!["lastName"] as! String
        let email =  userObj.value!["email"] as! String
        var commentRef = self.rootRef.child("forums").child("\(self.clickedForum!.uid)")
            commentRef.child("comments").childByAutoId().setValue(["postedBy": ("\(firstName) \(lastName)"), "postedID":self.currUser!.uid,"message": self.writeComment.text!, "displayPic": dp!,"commentPic": self.newImageURLVal])
        [MBProgressHUD .hideHUDForView(self.view, animated:true)]
        self.writeComment.text = ""
            let imageURL = NSURL(string: (""))
            if let url = imageURL {
                self.uploadedImage.sd_setImageWithURL(url)
            }
        let alert = UIAlertView()
        alert.title = "Saved"
        alert.message = "Message Saved"
        alert.addButtonWithTitle("Understood")
        alert.show()
        
        }) {(error) in
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
        
    }
    
    @IBAction func uploadImage(sender: UIButton) {
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
                    self.newImageURLVal = (metadata?.downloadURL()?.absoluteString)!
                    let imageURL = NSURL(string: self.newImageURLVal)
                    if let url = imageURL {
                        self.uploadedImage.sd_setImageWithURL(url)
                    }
                }
            })
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if comments[indexPath.row].commentImage == "" {
            let cell = tableView.dequeueReusableCellWithIdentifier("customCommentCell1", forIndexPath: indexPath) as! CustomCommentTableViewCell
        
            cell.message.text = comments[indexPath.row].message
        
        
            cell.userName.text = comments[indexPath.row].postedBy
        
            if let dp =  comments[indexPath.row].displayPic as? String {
                if dp != "" {
                    let imageURL = NSURL(string: dp)
                    if let url = imageURL {
                        cell.displayImage.sd_setImageWithURL(url)
                    }
                }
            
            }
            if currUser?.uid == comments[indexPath.row].postedID {
                cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {
                    (sender: MGSwipeTableCell!) -> Bool in
                    self.rootRef.child("forums").child("\(self.clickedForum!.uid)").child("comments").child("\(self.comments[indexPath.row].uid)").removeValue()
                    self.tableView.reloadData()
                    return true
                })]
                cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
            }
            return cell
        }
            let cell = tableView.dequeueReusableCellWithIdentifier("customCommentCell2", forIndexPath: indexPath) as! CustomComment2TableViewCell
            
            cell.message.text = comments[indexPath.row].message
            
            
            cell.userName.text = comments[indexPath.row].postedBy
            
            if let dp =  comments[indexPath.row].displayPic as? String {
                if dp != "" {
                    let imageURL = NSURL(string: dp)
                    if let url = imageURL {
                        cell.displayPic.sd_setImageWithURL(url)
                    }
                }
                
            }
        if let dp =  comments[indexPath.row].commentImage as? String {
            if dp != "" {
                let imageURL = NSURL(string: dp)
                if let url = imageURL {
                    cell.commentPic.sd_setImageWithURL(url)
                }
            }
            
        }
            if currUser?.uid == comments[indexPath.row].postedID {
                cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {
                    (sender: MGSwipeTableCell!) -> Bool in
                    self.rootRef.child("forums").child("\(self.clickedForum!.uid)").child("comments").child("\(self.comments[indexPath.row].uid)").removeValue()
                    self.tableView.reloadData()
                    return true
                })]
                cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
            }
        return cell
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
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
