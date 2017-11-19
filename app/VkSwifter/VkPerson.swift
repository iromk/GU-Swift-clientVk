//
//  VkSwifter.swift
//  vkClient
//
//  Created by Roman Syrchin on 11/9/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//
/* Что работает:
    Первичная авторизация через веб, сохранение токена в CoreData, авторизация по сохранненому токену.
    Загрузка с VK: профиля, друзей, автарок, фоток из альбома profile, групп.
    Сохранение в Realm объекта User в котором представлены все загруженные данные (кроме групп пока).
    Изображения берутся из папки tmp, если уже скачаны, или скачиваются и сохраняются в tmp с именем производным от id изображения.
    В демонстрационных целях можно выбирать профили кнопкой Switch на TableView друзей. И наблюдать через Realm browser как это все ханится.
    Какие-то баги наверняка работают.
 
 * Что пока не работает:
    Группы пользователя не сохраняются в Realm.
    Обзор всех групп и поиск по ним.
    Выход.
    Сохрание токена в KeyChain.
    Обновление сохраненных данных - если что-то уже сохранено в Realm, берется оттуда без проверки на наличие изменений на стороне VK.
 
*/

import Foundation
import SwiftyJSON
import RealmSwift

struct Vk {
    typealias Uid = Int
}

// each VK object has unique ID
protocol VkEntity {
    var uid: Vk.Uid { get set }
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
    var photos: List<Photo> { get set }
    func addPhotos(_ photos: JSON)
}

extension PhotoCollection {

    func addPhotos(_ photos: JSON) {
        print("adding photos...")
        print(photos)
        do {
            let realm = try Realm()
            realm.beginWrite()
            for (_, photo):(String,JSON) in photos["response"]["items"] {
                if let imageurl = photo["photo_807"].string { // there could be empty image urls
//                    print("adding photo \(imageurl)")
                    self.photos.append(Photo(url: imageurl, uid: photo["id"].intValue))
                }
            }
            try realm.commitWrite()
            print("photos added and saved:\n\(self.photos.count)")
        } catch {
            print("REALM addPhotos error \(error)")
        }
    }
    
}

/**
 * Common base class for VK human
 */
class VkPerson : Object, VkEntity, Named, PhotoCollection {
    
    // PhotoCollection
    var photos = List<Photo>()
    
    // Named
    @objc dynamic
    var lastName: String = ""
    @objc dynamic
    var firstName: String = ""
    
    // VkEntity
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
        do {
            let realm = try Realm()
            realm.beginWrite()
            for (_, friend):(String,JSON) in friends["response"]["items"] {
//                print("one by one: \(friend["last_name"])")
                self.friends.append(
                    Friend(friend["id"].intValue,
                           friend["first_name"].stringValue,
                           friend["last_name"].stringValue,
                           Avatar(url: friend["photo"].stringValue, of: friend["id"].intValue)))
            }
            try realm.commitWrite()
            print("friends parsed and saved:\n\(self.friends.count)")
        }
        catch { print("REALM addFriends error \(error)") }
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
