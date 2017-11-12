//
//  Group.swift
//  vkClient
//
//  Created by Roman Syrchin on 11/6/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation

class Group {
    
    var name: String?
    var ava: Vk.Image?
    
    init(_ name: String, _ imageurl: Vk.Image) {
        self.ava = imageurl
        self.name = name
    }
}
