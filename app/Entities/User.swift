//
//  User.swift
//  vkClient
//
//  Created by nnm on 11/6/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol Named {

    var firstName: String { get set }
    var lastName: String { get set }
    var fullName: String { get }
    
}

protocol PhotoCollection {
    var photos: [VkImage] { get set }
    func addPhotos(_ photos: JSON)
}

class VkPerson : Named, PhotoCollection {

    var photos: [VkImage]
    
    var lastName: String
    var firstName: String
    var fullName: String { get { return "\(firstName) \(lastName)" } }

    var uid: String?
    
    convenience init(name: (String?, String?)) {
        self.init( name.0, name.1)
    }
    
    init(_ firstName: String?, _ lastName: String?) {
        self.firstName = firstName!
        self.lastName = lastName!
        self.photos = [VkImage]()
    }
    
    var avatar: VkImage?
    var friends = [Friend]()
    var groups = [Group]()

    func addFriends(json friends: JSON) {
        print("adding friends...")
//        print(friends)
        for (_, friend):(String,JSON) in friends["response"]["items"] {
            self.friends.append(
                Friend(friend["id"].stringValue,
                       friend["first_name"].stringValue,
                       friend["last_name"].stringValue,
                       VkImage(url: friend["photo"].stringValue)))
        }
        print("friends parsed:\n\(self.friends.count)")
    }
    
    func addPhotos(_ photos: JSON) {
        for (_, photo):(String,JSON) in photos["response"]["items"] {
            if let imageurl = photo["photo_807"].string { // there could be empty image urls
                self.photos.append(VkImage(url: imageurl))
            }
        }
//        for p in self.photos {
//          print("url: [\(p.url!)]")
//        }
//        print("total phos: \(self.photos.count)")
    }
}

class User : VkPerson {
    
    
}
