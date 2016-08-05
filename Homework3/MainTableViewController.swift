//
//  MainTableViewController.swift
//  Homework3
//
//  Created by student on 8/2/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import Firebase

class MainTableViewController: UITableViewController {
    
    var items = ["Profile","Forum","Inbox","Users"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutButton(sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("loginUserStoryBoard") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainTableCell", forIndexPath: indexPath)
        cell.textLabel?.text = items[indexPath.row]

        return cell
    }
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //print(tableView.indexPathForSelectedRow)
        if items[tableView.indexPathForSelectedRow!.row] == "Profile" {
            
        }else if items[tableView.indexPathForSelectedRow!.row] == "Forum" {
            
        }else if items[tableView.indexPathForSelectedRow!.row] == "Inbox" {
            
        }else if items[tableView.indexPathForSelectedRow!.row] == "Users" {
            if let destination = segue.destinationViewController as? UsersTableViewController {
                //destination.data = AppsData.data[viaSegue]![(tableView.indexPathForSelectedRow?.row)!]

            }

        }
    }
    

}
