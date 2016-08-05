//
//  LoginViewController.swift
//  Homework3
//
//  Created by student on 7/29/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import FirebaseStorage

class LoginViewController: UIViewController {
     
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.text = "paraball@uncc.edu"
        password.text = "paraball"
    }
    
//    override func viewDidAppear(animated: Bool) {
//        if ((FIRAuth.auth()?.currentUser) != nil){
//            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc : UINavigationController = storyboard.instantiateViewControllerWithIdentifier("mainNavigationStoryBoard") as! UINavigationController
//            self.presentViewController(vc, animated: true, completion: nil)
//            
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginButton(sender: UIButton) {
        
        if self.email.text == ""
            || self.password.text == "" {
            let alert = UIAlertView()
            alert.title = "Oops"
            alert.message = "Null Fields"
            alert.addButtonWithTitle("Understood")
            alert.show()
        }else {
            [MBProgressHUD .showHUDAddedTo(self.view, animated:true)]
            FIRAuth.auth()?.signInWithEmail(self.email.text!, password: self.password.text!, completion: { (user, error) in
                if error == nil {
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc : UINavigationController = storyboard.instantiateViewControllerWithIdentifier("mainNavigationStoryBoard") as! UINavigationController
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
