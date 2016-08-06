//
//  ForumsTableViewController.swift
//  Homework3
//
//  Created by student on 8/5/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import MBProgressHUD
import FirebaseStorage
import MGSwipeTableCell

class ForumsTableViewController: UITableViewController {
    var currUser = FIRAuth.auth()?.currentUser
    var rootRef = FIRDatabase.database().reference()
    var posts = [ForumPosts]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Forums"
        fetchPosts()
    }
    
    func fetchPosts() {
        [MBProgressHUD .showHUDAddedTo(self.view, animated:true)]
        rootRef.child("forums").observeEventType(.Value, withBlock: { (snapshot) -> Void in
            self.posts.removeAll()
            let enumerator = snapshot.children
            while let message = enumerator.nextObject() as? FIRDataSnapshot {
                let uid = message.key
                let displayPic = message.value!["displayPic"] as? String
                let postedID = message.value!["postedID"] as? String
                let postedBy = message.value!["postedBy"] as? String
                let message = message.value!["message"] as? String
                let userObj = ForumPosts(postedBy: postedBy!,postedID: postedID!,message: message!, displayPic: displayPic!,uid: uid)
                self.posts.append(userObj)

            }
            [MBProgressHUD .hideHUDForView(self.view, animated:true)]
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("forumsCell", forIndexPath: indexPath) as! CustomForumsTableViewCell
        
        cell.message.text = posts[indexPath.row].message


        cell.userName.text = self.posts[indexPath.row].postedBy

        if let dp =  self.posts[indexPath.row].displayPic as? String {
            if dp != "" {
                let imageURL = NSURL(string: dp)
                if let url = imageURL {
                    cell.displayPic.sd_setImageWithURL(url)
                }
            }
            
        }
        if currUser?.uid == self.posts[indexPath.row].postedID {
            cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                self.rootRef.child("forums").child("\(self.posts[indexPath.row].uid)").removeValue()
                self.tableView.reloadData()
                return true
            })]
            cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
        }
        
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "commentSegue":
            let destination = segue.destinationViewController as! ForumViewController
            destination.clickedForum = posts[(tableView.indexPathForSelectedRow?.row)!]
        case "newForumPostSegue" :
            let destination = segue.destinationViewController as! ForumsViewController
        default:
            break
        }
    }

}
