//
//  UserSession.swift
//  clientVk
//
//  Created by Roman Syrchin on 10/26/17.
//  Copyright © 2017 Roman Sыrchin. All rights reserved.
//

import WebKit
import SwiftyJSON
import RealmSwift

class UserSession {
    
    enum State {
        case opened, closed
    }
    
    var realm: Realm?
    
    static var thisSession: UserSession?
    
    var userx: Auth.ArrayProvider.Account?
    
    var vk: VkApiProvider?
    
    var user = User(name: ( "John", "Doe"))
    
    let testUids: [String: Vk.Uid] = [ "Donald J. Trump": 395319196,
                     "Some guy":292290347,
                     "Jennifer Lawrence":203067262,
                     "Olivia Wilde":215563638]
    
    

    var state: State { get { return user == nil ? .closed : .opened } }
    
    init() {
        user.uid = testUids["Olivia Wilde"]!
//        user.save()
        do {
            print("\nrealm url: \(Realm.Configuration.defaultConfiguration.fileURL)\n")

            realm = try Realm()
            let realmuser = realm!.objects(User.self).first as? User
//            let realmuser = realm.object(ofType: User.self, forPrimaryKey: 215563638 )
            let n = realmuser?.lastName
            print("realm user: \(n).")
        } catch {
            print("session init realm error \(error)")
        }
    }
    
    func beginSession(withUid uid: Vk.Uid?) {
        user = User()
        user.uid = uid!
        vk!.uid = uid!
        user.friends.removeAll()
        user.photos.removeAll()
        user.groups.removeAll()
        getUserProfile()
    }
    
    static func getInstance() -> UserSession {
        if thisSession == nil {
            thisSession = UserSession()
        }
        return thisSession!
    }
    
    func save() {
        print("REALM: saving user")
        do {
            realm!.beginWrite()
            realm!.add(user)
            try realm!.commitWrite()
        } catch {
            print("real error: \(error)")
        }
    }

    
    func requestAuthorizationUrl(through vk: Auth.VkProvider) -> URLRequest {
        return vk.requestAuth()
    }

    func authorize(with token: String) {
        vk = VkApiProvider(uid: user.uid, with: token)
        getUserProfile()
    }
    
    func getUserProfile() {
        print("in getUserProfile")
        do {
            let realm = try Realm()
            if let user1 = realm.object(ofType: User.self, forPrimaryKey: user.uid) as? User {
                user = user1
            }
        }catch {
            print("getUserProfile realm error \(error)")
        }
        vk!.apiUsersGet(uids: JSON(user.uid))
        { json in
            let jsonuser = json["response"][0]
            self.user.firstName = jsonuser["first_name"].stringValue
            self.user.lastName = jsonuser["last_name"].stringValue
            self.user.avatar = Avatar(url: jsonuser["photo"].stringValue, of: self.user.uid)
            print ("Session: \(self.user.fullName)")
            self.save()
//            self.user.save()
        }
    }
    
//
//    func authorize(login: String, password: String) -> Bool {
//        if let result = Auth.ArrayProvider.check(login, with: password) {
//            userx = result
//            return true
//        }
//        return false
//    }
}

