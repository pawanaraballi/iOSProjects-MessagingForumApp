//
//  SignUpViewController.swift
//  Homework3
//
//  Created by student on 7/29/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import Toast_Swift

class SignUpViewController: UIViewController {
    
    let rootRef = FIRDatabase.database().reference()

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var usss : (firstName:String, lastName:String, email:String , password:String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitButton(sender: UIButton) {
        let userRef = rootRef.child("users")
        
        if self.firstName.text == "" || self.lastName.text == "" || self.email.text == ""
            || self.password.text == "" || self.confirmPassword.text == "" {
            let alert = UIAlertView()
            alert.title = "Oops"
            alert.message = "Null Fields"
            alert.addButtonWithTitle("Understood")
            alert.show()
        }else if self.password.text != self.confirmPassword.text {
            let alert = UIAlertView()
            alert.title = "Oops"
            alert.message = "Password Incorrect"
            alert.addButtonWithTitle("Understood")
            alert.show()
        }else {
            [MBProgressHUD .showHUDAddedTo(self.view, animated:true)]
            FIRAuth.auth()?.createUserWithEmail(self.email.text!, password: self.password.text!, completion: { (user, error) in
                if error == nil {
                    
                    userRef.child((user?.uid)!).setValue(["firstName": self.firstName.text!,"lastName": self.lastName.text!,"email": self.email.text!,"password": self.password.text!,"displayPic":""])
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("mainNavigationStoryBoard") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                    
                }else {
                    let alert = UIAlertView()
                    alert.title = "Oops"
                    alert.message = error?.localizedDescription
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
                [MBProgressHUD .hideHUDForView(self.view, animated:true)]
            })
        }
        
    }

    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "loginsuccess" && loginsuccess {
//            self.view.makeToast("Account Created")
//        }
//    }
    
    
//    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
//        if let ident = identifier {
//            if ident == "loginsuccess" {
//                if loginsuccess != true {
//                    return true
//                }
//            }
//        }
//        return false
//    }
    

}
