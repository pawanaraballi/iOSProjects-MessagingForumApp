//
//  Messages.swift
//  Homework3
//
//  Created by student on 8/5/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import Foundation

class Messages {
    var sentID : String = ""
    var sentName: String = ""
    var displayPic:String = ""
    var receiverID : String = ""
    var read : String = ""
    var message : String = ""
    var uid : String = ""
    var receiverName:String = ""
    var receiverdisplayPic : String = ""
    
    init(sentID: String,sentName:String, displayPic:String, receiverID : String,receiverName : String, receiverdisplayPic:String, read: String, message : String,uid:String) {
        self.sentID = sentID
        self.displayPic = displayPic
        self.sentName = sentName
        self.message = message
        self.read = read
        self.receiverID = receiverID
        self.uid = uid
        self.receiverdisplayPic = receiverdisplayPic
        self.receiverName = receiverName
    }
}