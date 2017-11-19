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
    
    enum State { case opened, closed }
    var state: State {
        get {
            if let token = UserDefaults.standard.string(forKey: "token") {
                return .opened
            }
            return .closed
        }
        set(newValue) {
            if newValue == .closed {
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "account")
            }
            if newValue == .opened {
            }
        }
    }
    
    var realm: Realm?
    
    static var thisSession: UserSession?
    
    var userx: Auth.ArrayProvider.Account?
    
    var vk: VkApiProvider?
    
    var user = User(name: ( "John", "Doe"))
    
    let testUids: [String: Vk.Uid] = [ "Donald J. Trump": 395319196,
                                       "Some guy": 292290347,
                                       "Jennifer Lawrence": 203067262,
                                       "Olivia Wilde":215563638]
    
    init() {
        user.uid = testUids["Jennifer Lawrence"]!
        do {
            print("\n\n*** REALM URL:\n\(Realm.Configuration.defaultConfiguration.fileURL!)\n***\n\n")
            realm = try Realm()
            let realmuser = realm!.objects(User.self).first as? User
            let n = realmuser?.lastName
            print("realm user: \(n).")
        } catch {
            print("session init realm error \(error)")
        }
        if state == .opened {
            authorize(account: UserDefaults.standard.integer(forKey: "account"), with: UserDefaults.standard.string(forKey: "token")!)
        }
    }
    
    func deleteWebViewData(completion: @escaping () -> Void) {
        let dateFrom = NSDate(timeIntervalSince1970: 0)
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom as Date, completionHandler: {() -> Void in
            UserDefaults.standard.synchronize()
            
            completion()
        })
    }

    func authorize(account: Vk.Uid, with token: String) {
        vk = VkApiProvider(uid: user.uid, with: token)
        UserDefaults.standard.set(account, forKey: "account")
        UserDefaults.standard.set(token, forKey: "token")
        getUserProfile()
    }
    
    func beginSession(withUid uid: Vk.Uid?) {
        print("begin session \(uid)")
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
            print("realm error: \(error)")
        }
    }

    
    func requestAuthorizationUrl(through vk: Auth.VkProvider) -> URLRequest {
        return vk.requestAuth()
    }

    func getUserProfile() {
        do {
            realm = try Realm()
            if let realmUser = realm!.object(ofType: User.self, forPrimaryKey: user.uid) {
                self.user = realmUser
                print ("REALM Session: \(self.user.fullName)")
            } else {
                vk!.apiUsersGet(uids: JSON(user.uid))
                { json in
                    let jsonuser = json["response"][0]
                    self.user.firstName = jsonuser["first_name"].stringValue
                    self.user.lastName = jsonuser["last_name"].stringValue
                    self.user.avatar = Avatar(url: jsonuser["photo"].stringValue, of: self.user.uid)
                    print ("Session: \(self.user.fullName)")
                    self.save()
                }
            }
        }catch {
            print("getUserProfile realm error \(error)")
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

