//
//  User.swift
//  vkClient
//
//  Created by nnm on 11/6/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation

class User {
    
    var firstName: String?
    var lastName: String?
    
    var friends = [String: Friend]()
    var groups: [Group]?
    var ava: Picture?

    convenience init(name: (String?, String?)) {
        self.init(firstName: name.0, lastName: name.1)
    }

    init(firstName: String?, lastName: String?) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
}
