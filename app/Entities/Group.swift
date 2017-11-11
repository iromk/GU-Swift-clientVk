//
//  Group.swift
//  vkClient
//
//  Created by nnm on 11/6/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation

class Group {
    
    var name: String?
    var ava: VkImage?
    
    init(_ name: String, _ imageurl: VkImage) {
        self.ava = imageurl
        self.name = name
    }
}
