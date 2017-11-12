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
//    var photos: [VkImage] { get set }
    var photos: List<Photo> { get set }
    func addPhotos(_ photos: JSON)
}

extension PhotoCollection {

    func addPhotos(_ photos: JSON) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            for (_, photo):(String,JSON) in photos["response"]["items"] {
                if let imageurl = photo["photo_807"].string { // there could be empty image urls
                    print("adding photo \(imageurl)")
                    self.photos.append(Photo(url: imageurl, uid: photo["id"].intValue))
                }
            }
            try realm.commitWrite()
        } catch {
            print("REALM addPhotos error \(error)")
        }
        //        for p in self.photos {
        //          print("url: [\(p.url!)]")
        //        }
        //        print("total phos: \(self.photos.count)")
    }
    
}

class VkPerson : Object, Named, PhotoCollection {
    
    var photos = List<Photo>()
    
    @objc dynamic
    var lastName: String = ""
    @objc dynamic
    var firstName: String = ""
    
    @objc dynamic
    var uid: Vk.Uid = 0
    
    convenience init(_ firstName: String?, _ lastName: String?) {
        self.init()
        self.firstName = firstName ?? "Anony"
        self.lastName = lastName ?? "Mous"
    }

    convenience init(name: (String?, String?)) {
        self.init( name.0, name.1)
    }
    
    convenience init(_ uid: Vk.Uid, _ firstName: String, _ lastName: String, _ avatar: Avatar ) {
        self.init(firstName, lastName)
        self.uid = uid
        self.avatar = avatar
    }
   
    @objc dynamic
    var avatar: Avatar?
    var friends = List<Friend>()
    var groups = [Group]()
    
    func addFriends(json friends: JSON) {
        print("adding friends...")
        //        print(friends)

        do {
            let realm = try Realm()
            realm.beginWrite()
            for (_, friend):(String,JSON) in friends["response"]["items"] {
                print("one by one: \(friend["last_name"])")
                self.friends.append(
                    Friend(friend["id"].intValue,
                           friend["first_name"].stringValue,
                           friend["last_name"].stringValue,
                           Avatar(url: friend["photo"].stringValue, of: friend["id"].intValue)))
            }
            print("friends parsed:\n\(self.friends.count)")
            try realm.commitWrite()
        }
        catch { print("REALM addFriends error \(error)")}
    }
    
    func addGroups(json groups: JSON) {
        for (_, group):(String,JSON) in groups["response"]["items"] {
            self.groups.append(
                Group(group["name"].stringValue,
                      VkImage(url: group["photo_50"].stringValue, uid: group["id"].intValue)))
        }
        print("groups parsed:\n\(self.groups.count)")
    }
    
}
