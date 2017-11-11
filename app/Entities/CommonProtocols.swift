//
//  CommonProtocols.swift
//  vkClient
//
//  Created by nnm on 11/9/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

protocol VkEntity {
    var uid: Int32 { get set }
}

protocol Named {
    
    var firstName: String { get set }
    var lastName: String { get set }
    var fullName: String { get }
    
}

extension Named {

    var fullName: String { get { return "\(firstName) \(lastName)" } }

}

protocol PhotoCollection : class {
    var photos: [VkImage] { get set }
    func addPhotos(_ photos: JSON)
}

extension PhotoCollection {

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

class VkPerson : Named, PhotoCollection {
    
    var photos: [VkImage] = []
    
    var lastName: String = ""
    var firstName: String = ""
    
    var uid: UInt32 = 0
    
    init(_ firstName: String?, _ lastName: String?) {
        self.firstName = firstName ?? "Anony"
        self.lastName = lastName ?? "Mous"
    }

    convenience init(name: (String?, String?)) {
        self.init( name.0, name.1)
    }
    
    convenience init(_ uid: UInt32, _ firstName: String, _ lastName: String, _ avatar: VkImage ) {
        self.init(firstName, lastName)
        self.uid = uid
        self.avatar = avatar
    }

   
    var avatar: VkImage?
    var friends = [Friend]()
    var groups = [Group]()
    
    func addFriends(json friends: JSON) {
        print("adding friends...")
        //        print(friends)
        for (_, friend):(String,JSON) in friends["response"]["items"] {
            self.friends.append(
                Friend(friend["id"].uInt32Value,
                       friend["first_name"].stringValue,
                       friend["last_name"].stringValue,
                       VkImage(url: friend["photo"].stringValue)))
        }
        print("friends parsed:\n\(self.friends.count)")
    }
    
    func addGroups(json groups: JSON) {
        for (_, group):(String,JSON) in groups["response"]["items"] {
            self.groups.append(
                Group(group["name"].stringValue,
                      VkImage(url: group["photo_50"].stringValue)))
        }
        print("groups parsed:\n\(self.groups.count)")
    }
    
}
