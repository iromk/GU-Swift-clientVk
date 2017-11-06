//
//  UserSession.swift
//  Homework01
//
//  Created by nnm on 10/26/17.
//  Copyright © 2017 Roman Sыrchin. All rights reserved.
//

import WebKit

class UserSession {
    
    enum State {
        case opened, closed
    }
    
    static var thisSession: UserSession?
    
    var userx: Auth.ArrayProvider.Account?
    
    var vk: VkApiProvider?
    let testUid = "292290347"
    
    var userObject: User?
    
    var user: User { get {
                guard let _ = userObject!.lastName else {
                    var name: (String?, String?) = vk!.getUserName() 
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
        vk!.requestFriendsGet()
    }
    
    func getFirstName() -> String {
        var name: (String, String) = vk!.getUserName() as! (String, String)
        return name.0
    }

    func getLastName() -> String {
        var name: (String, String) = vk!.getUserName() as! (String, String)
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
