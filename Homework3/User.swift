//
//  User.swift
//  Homework3
//
//  Created by student on 8/4/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import Foundation

class User {
    var firstName : String = ""
    var lastName : String = ""
    var email : String = ""
    var displayPic : String = ""
    var uid : String = ""
    
    init(firstName: String, lastName : String, email: String, displayPic : String,uid:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.displayPic = displayPic
        self.uid = uid
    }
}
