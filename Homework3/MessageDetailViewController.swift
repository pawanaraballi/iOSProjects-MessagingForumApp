//
//  MessageDetailViewController.swift
//  Homework3
//
//  Created by student on 8/5/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import SDWebImage

class MessageDetailViewController: UIViewController {

    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var dp = ""
    var userN = ""
    var mess = ""
    var receiverID = ""
    var receiverName = ""
    var receiverdisplayPic = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        message.text = mess
        userName.text = userN
        if dp != "" {
            let imageURL = NSURL(string: dp)
            if let url = imageURL {
                displayImage.sd_setImageWithURL(url)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "replySegue":
            let uid = receiverID
            if let destination = segue.destinationViewController as? MessageViewController {
                let sentName = receiverName
                let displayPic = receiverdisplayPic
                destination.clickedUser = User(firstName: sentName,lastName: "",email: "",displayPic: displayPic,uid: uid)
                
            }
        default:
            break
        }
    }
    

}
