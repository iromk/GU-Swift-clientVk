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
//    let testUid = "292290347" // some guy
    let testUid = "203067262" // Jennifer Lawrence
    
    var user = User(name: ( "John", "Doe"))
    
    var state: State { get { return user == nil ? .closed : .opened } }
    
    init() {
        user.uid = testUid
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
        getUserProfile()
    }
    
    func getUserProfile() {
        vk!.apiUsersGet(uids: JSON(user.uid!))
        { json in
            let jsonuser = json["response"][0]
            self.user.firstName = jsonuser["first_name"].stringValue
            self.user.lastName = jsonuser["last_name"].stringValue
            self.user.avatar = VkImage(url: jsonuser["photo"].stringValue)
        }
    }
    
       
    func authorize(login: String, password: String) -> Bool {
        if let result = Auth.ArrayProvider.check(login, with: password) {
            userx = result
            return true
        }
        return false
    }
}
