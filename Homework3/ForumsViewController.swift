//
//  ForumsViewController.swift
//  Homework3
//
//  Created by student on 8/5/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class ForumsViewController: UIViewController {
    var currUser = FIRAuth.auth()?.currentUser
    var rootRef = FIRDatabase.database().reference()
    @IBOutlet weak var forumMessage: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Forum Post"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func submitButton(sender: UIBarButtonItem) {
        [MBProgressHUD .showHUDAddedTo(self.view, animated:true)]
        self.rootRef.child("users").child((currUser?.uid)!).observeEventType(.Value, withBlock: { (snapshot) -> Void in
            let userObj = snapshot
            let dp =  userObj.value!["displayPic"] as? String
            let firstName =  userObj.value!["firstName"] as! String
            let lastName =  userObj.value!["lastName"] as! String
            let email =  userObj.value!["email"] as! String
            self.rootRef.child("forums").childByAutoId().setValue(["postedBy": ("\(firstName) \(lastName)"),"postedID":self.currUser!.uid,"message": self.forumMessage.text, "displayPic" : dp ,"uid": self.currUser?.uid])
            [MBProgressHUD .hideHUDForView(self.view, animated:true)]
            let alert = UIAlertView()
            alert.title = "Saved"
            alert.message = "Message Saved"
            alert.addButtonWithTitle("Understood")
            alert.show()
            
        }) {(error) in
            print(error.localizedDescription)
        }
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
