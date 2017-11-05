//
//  UserSession.swift
//  Homework01
//
//  Created by nnm on 10/26/17.
//  Copyright © 2017 Roman Sыrchin. All rights reserved.
//

class UserSession {
    
    enum State {
        case opened, closed
    }
    
    static var thisSession: UserSession?
    
    var user: Auth.Account?
    
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
    
    func authorize(login: String, password: String) -> Bool {
        if let result = Auth.check(login, with: password) {
            user = result
            return true
        }
        user = nil
        return false
    }
    
    
}
