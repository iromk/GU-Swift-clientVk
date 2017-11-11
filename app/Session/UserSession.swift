//
//  UserSession.swift
//  Homework01
//
//  Created by nnm on 10/26/17.
//  Copyright © 2017 Roman Sыrchin. All rights reserved.
//

import WebKit
import SwiftyJSON

class UserSession {
    
    enum State {
        case opened, closed
    }
    
    static var thisSession: UserSession?
    
    var userx: Auth.ArrayProvider.Account?
    
    var vk: VkApiProvider?
    
    var user = User(name: ( "John", "Doe"))
    
    let testUids: [String: UInt32] = [ "Donald J. Trump": 395319196,
                     "Some guy":292290347,
                     "Jennifer Lawrence":203067262,
                     "Olivia Wilde":215563638]
    
    

    var state: State { get { return user == nil ? .closed : .opened } }
    
    init() {
        user.uid = testUids["Olivia Wilde"]!
    }
    
    func beginSession(withUid uid: UInt32?) {
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
    
    func requestAuthorizationUrl(through vk: Auth.VkProvider) -> URLRequest {
        return vk.requestAuth()
    }

    func authorize(with token: String) {
        vk = VkApiProvider(uid: user.uid, with: token)
        getUserProfile()
    }
    
    func getUserProfile() {
        print("in getUserProfile")
        vk!.apiUsersGet(uids: JSON(user.uid))
        { json in
            let jsonuser = json["response"][0]
            self.user.firstName = jsonuser["first_name"].stringValue
            self.user.lastName = jsonuser["last_name"].stringValue
            self.user.avatar = VkImage(url: jsonuser["photo"].stringValue)
            print ("Session: \(self.user.fullName)")
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

