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
//    let testUid = "292290347"
    let testUid = "203067262"
    
    var userObject: User?
    
    var user: User { get {
                guard let _ = userObject!.lastName else {
                    let name: (String?, String?) = vk!.getUserName()
                    userObject?.firstName = name.0
                    userObject?.lastName = name.1
                    return userObject!
                }
                return userObject!
        } }
    
    var state: State { get { return userObject == nil ? .closed : .opened } }
    
    init() {
        userObject = nil
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
        vk = VkApiProvider(uid: testUid, with: token)
        userObject = User(name: vk!.getUserName() )
    }
    
    func addFriends(json friends: JSON) {
        print("adding friends...")
        for (_, friend):(String,JSON) in friends["response"] {
            self.user.friends.append(Friend(friend["id"].stringValue,
                                            friend["first_name"].stringValue,
                                            friend["last_name"].stringValue))
        }
        print("friends parsed:\n\(self.user.friends.count)")
    }
    
    func getFirstName() -> String {
        let name: (String, String) = vk!.getUserName() as! (String, String)
        return name.0
    }

    func getLastName() -> String {
        let name: (String, String) = vk!.getUserName() as! (String, String)
        return name.1
    }

    func authorize(login: String, password: String) -> Bool {
        if let result = Auth.ArrayProvider.check(login, with: password) {
            userx = result
            return true
        }
        userObject = nil
        return false
    }
}
