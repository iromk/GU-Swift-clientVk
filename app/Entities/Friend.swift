//
//  Friend.swift
//  vkClient
//
//  Created by nnm on 11/6/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation

class Friend : VkPerson {
    
    var fullName: String {
        get {
            return "\(firstName) \(lastName)"
        } }
    
    init(_ uid: String, _ firstName: String, _ lastName: String, _ avatar: VkImage ) {
        super.init(firstName, lastName)
        self.uid = uid
        self.avatar = avatar
    }
}
