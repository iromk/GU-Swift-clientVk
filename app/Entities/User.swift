//
//  User.swift
//  vkClient
//
//  Created by nnm on 11/6/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation
import UIKit

protocol Namable {

    var firstName: String { get set }
    var lastName: String { get set }
    
}

class VkPerson : Namable {
    var lastName: String
    var firstName: String
    var uid: String?
    
    convenience init(name: (String?, String?)) {
        self.init( name.0, name.1)
    }
    
    init(_ firstName: String?, _ lastName: String?) {
        self.firstName = firstName!
        self.lastName = lastName!
    }
    
    var avatar: VkImage?
}

class User : VkPerson {
    
    var friends = [Friend]()
    var groups = [Group]()
    
}
