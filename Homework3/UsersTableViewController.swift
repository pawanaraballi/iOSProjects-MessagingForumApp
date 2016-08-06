//
//  UsersTableViewController.swift
//  Homework3
//
//  Created by student on 8/4/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class UsersTableViewController: UITableViewController {
    
    let rootRef = FIRDatabase.database().reference()
    var users = [User]()
    let currentUser = FIRAuth.auth()?.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    func fetchUsers() {
        [MBProgressHUD .showHUDAddedTo(self.view, animated:true)]
        rootRef.child("users").observeEventType(.Value, withBlock: { (snapshot) -> Void in
            self.users.removeAll()
            let enumerator = snapshot.children
            while let user = enumerator.nextObject() as? FIRDataSnapshot {
                let uid = user.key
                let firstName = user.value!["firstName"] as? String
                let lastName = user.value!["lastName"] as? String
                let email = user.value!["email"] as? String
                let displayPic = user.value!["displayPic"] as? String
                let userObj = User(firstName: firstName!, lastName: lastName!, email: email!, displayPic: displayPic!, uid: uid)
                self.users.append(userObj)
            }
            [MBProgressHUD .hideHUDForView(self.view, animated:true)]
            self.tableView.reloadData()
        }) {(error) in
            print(error.localizedDescription)
        }
        
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("usersCell", forIndexPath: indexPath) as! UserTableViewCell

        cell.userName.text = (" \(users[indexPath.row].firstName) \(users[indexPath.row].lastName) ")
        if users[indexPath.row].displayPic != "" {
            let imageURL = NSURL(string: users[indexPath.row].displayPic)
            if let url = imageURL {
                cell.displayPic.sd_setImageWithURL(url)
            }

        }
        cell.displayPic.layer.borderWidth = 1
        cell.displayPic.layer.masksToBounds = false
        cell.displayPic.layer.borderColor = UIColor.blackColor().CGColor
        cell.displayPic.layer.cornerRadius = cell.displayPic.frame.height/2
        cell.displayPic.clipsToBounds = true

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "inviteeSegue":
            let destination = segue.destinationViewController as! InviteViewController
            //destination.clickedUser = users[(tableView.indexPathForSelectedRow?.row)!]
        case "userSegue" :
            let destination = segue.destinationViewController as! UserViewController
            destination.clickedUser = users[(tableView.indexPathForSelectedRow?.row)!]
        default:
            break
        }
    }
    

}
