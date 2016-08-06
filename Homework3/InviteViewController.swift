//
//  InviteViewController.swift
//  Homework3
//
//  Created by student on 8/5/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class InviteViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    var currUser = FIRAuth.auth()?.currentUser
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var inviteeMessage: UITextView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButton(sender: UIBarButtonItem) {
        let key = "key-7baa820349b8f29529db2c5710cecca2"
        
        let parameters = [
            "from": currUser?.email,
            "to": email.text,
            "subject": "From the Forum App - Pawan Araballi",
            "text": inviteeMessage.text
        ]
        
        let r = Alamofire.request(.POST, "https://api.mailgun.net/v3/sandbox0730f8b81c9f44d0b8f85eac0b4bbf13.mailgun.org/messages", parameters:parameters)
            .authenticate(user: "api", password: key)
            .response { (request, response, data, error) in
                print(request)
                print(response)
                print(error)
        }
        debugPrint(r)
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
