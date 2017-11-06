//
//  Friend.swift
//  vkClient
//
//  Created by nnm on 11/6/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation

class Friend {
    
    var firstName: String?
    var lastName: String?
    var uid: String?
    var fullName: String { get { return "\(firstName ?? "John") \(lastName ?? "Doe")" } }
    
    init(_ uid: String, _ firstName: String, _ lastName: String ) {
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
    }
    
    

}
