//
//  CommonProtocols.swift
//  vkClient
//
//  Created by Roman Syrchin on 11/9/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

protocol VkEntity {
    var uid: Vk.Uid { get set }
}

extension Vk {
    typealias Uid = Int
    
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
    var photos: [Vk.Image] { get set }
    func addPhotos(_ photos: JSON)
}

extension PhotoCollection {

    func addPhotos(_ photos: JSON) {
        for (_, photo):(String,JSON) in photos["response"]["items"] {
            if let imageurl = photo["photo_807"].string { // there could be empty image urls
                self.photos.append(Vk.Image(url: imageurl))
            }
        }
        //        for p in self.photos {
        //          print("url: [\(p.url!)]")
        //        }
        //        print("total phos: \(self.photos.count)")
    }
    
}

class VkPerson : Object, Named, PhotoCollection {
    
    var photos: [Vk.Image] = []
    
    @objc dynamic var lastName: String = ""
    @objc dynamic var firstName: String = ""
    
    @objc dynamic var uid: Vk.Uid = 0
    
    override static func primaryKey() -> String? {
        return "uid"
    }
    
    func save() {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(self)
            try realm.commitWrite()
        } catch {
            print("real error: \(error)")
        }
    }
    
    convenience init(_ firstName: String?, _ lastName: String?) {
        self.init()
        self.firstName = firstName ?? "Anony"
        self.lastName = lastName ?? "Mous"
    }

    convenience init(name: (String?, String?)) {
        self.init( name.0, name.1)
    }
    
    convenience init(_ uid: Vk.Uid, _ firstName: String, _ lastName: String, _ avatar: Vk.Image ) {
        self.init(firstName, lastName)
        self.uid = uid
        self.avatar = avatar
    }
   
    var avatar: Vk.Image?
    var friends = List<Friend>() //[Friend]()
    var groups = [Group]()
    
    func addFriends(json friends: JSON) {
        print("adding friends...")
        //        print(friends)
        return
        for (_, friend):(String,JSON) in friends["response"]["items"] {
            self.friends.append(
                Friend(friend["id"].intValue,
                       friend["first_name"].stringValue,
                       friend["last_name"].stringValue,
                       Vk.Image(url: friend["photo"].stringValue)))
        }
        print("friends parsed:\n\(self.friends.count)")
//        save()
    }
    
    func addGroups(json groups: JSON) {
        for (_, group):(String,JSON) in groups["response"]["items"] {
            self.groups.append(
                Group(group["name"].stringValue,
                      Vk.Image(url: group["photo_50"].stringValue)))
        }
        print("groups parsed:\n\(self.groups.count)")
    }
    
}
