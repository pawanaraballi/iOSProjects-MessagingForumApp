//
//  InboxTableViewController.swift
//  Homework3
//
//  Created by student on 8/5/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import MBProgressHUD
import MGSwipeTableCell

class InboxTableViewController: UITableViewController {
    let rootRef = FIRDatabase.database().reference()
    var messages = [Messages]()
    let currentUser = FIRAuth.auth()?.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Inbox"
        fetchMessages()
    }

    func fetchMessages() {
        [MBProgressHUD .showHUDAddedTo(self.view, animated:true)]
        rootRef.child("messages").observeEventType(.Value, withBlock: { (snapshot) -> Void in
            self.messages.removeAll()
            let enumerator = snapshot.children
            while let message = enumerator.nextObject() as? FIRDataSnapshot {
                let uid = message.key
                let sentName = message.value!["sentName"] as? String
                let displayPic = message.value!["DisplayPic"] as? String
                let receiverName = message.value!["receiverName"] as? String
                let receiverdisplayPic = message.value!["receiverdisplayPic"] as? String
                let sentID = message.value!["sentID"] as? String
                let receiverID = message.value!["receiverID"] as? String
                let read = message.value!["read"] as? String
                let message = message.value!["message"] as? String
                if receiverID == self.currentUser!.uid {
                    let userObj = Messages(sentID: sentID!,sentName: sentName!,displayPic: displayPic!,receiverID: receiverID!,receiverName: receiverName!, receiverdisplayPic: receiverdisplayPic!,read: read!,message: message!,uid: uid)
                    self.messages.append(userObj)
                }
            }
            [MBProgressHUD .hideHUDForView(self.view, animated:true)]
            self.tableView.reloadData()
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inboxCell", forIndexPath: indexPath) as! CustomInboxTableViewCell

        cell.message.text = messages[indexPath.row].message
        if messages[indexPath.row].read == "true" {
            cell.readMessage.hidden = true
        }else {
            cell.readMessage.hidden = false
        }
        let imageURL = NSURL(string: messages[indexPath.row].displayPic)
        if let url = imageURL {
            cell.displayPic.sd_setImageWithURL(url)
        }
        cell.userName.text = messages[indexPath.row].sentName

        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            var alert = UIAlertController(title: "Photo Delete", message: "Do you want to delete this photo", preferredStyle: .Alert)
            
            //3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                self.rootRef.child("messages").child("\(self.messages[indexPath.row].uid)").removeValue()
                self.tableView.reloadData()
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            }))
            
            // 4. Present the alert.
            self.presentViewController(alert, animated: true, completion: nil)

            return true
        })]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D


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
        case "messageDetailSegue":
            if let destination = segue.destinationViewController as? MessageDetailViewController {
                destination.userN = self.messages[tableView.indexPathForSelectedRow!.row].sentName
                destination.dp = self.messages[tableView.indexPathForSelectedRow!.row].displayPic
                destination.mess = self.messages[tableView.indexPathForSelectedRow!.row].message
                destination.receiverID = self.messages[tableView.indexPathForSelectedRow!.row].receiverID
                destination.receiverName = self.messages[tableView.indexPathForSelectedRow!.row].receiverName
                destination.receiverdisplayPic = self.messages[tableView.indexPathForSelectedRow!.row].receiverdisplayPic
                self.rootRef.child("messages").child("\(self.messages[tableView.indexPathForSelectedRow!.row].uid)").child("read").setValue("true")
            }
        case "messageselectuserSegue":
            if let destination = segue.destinationViewController as? MessageSelectUserViewController {

            }
        default:
            break
        }
    }
 

}
