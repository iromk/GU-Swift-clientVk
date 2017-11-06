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
    
    var user: Auth.ArrayProvider.Account?
    
    var vk: VkApiProvider?
    let testUid = "292290347"
    var firstName: String? { get { return getFirstName() }}
    var lastName: String? { get { return getLastName() }}
   
    var state: State { get { return user == nil ? .closed : .opened } }
    
    init() {
        user = nil
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
        print("token2: [\(token)]")
        vk = VkApiProvider(uid: testUid, with: token)
        vk!.getUserName()
//        (firstName, lastName) = vk!.getUserName()
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
            user = result
            return true
        }
        user = nil
        return false
    }
    
    
}
