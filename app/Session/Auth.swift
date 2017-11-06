//
//  Auth.swift
//  Homework01
//
//  Created by nnm on 10/26/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation

class Auth {

    struct Account {
        let login: String
        let password: String
        let name: String
    }

    struct ArrayProvider {
        
        static let users: [Account] = [ Account(login:"neo", password:"1", name:"Mr. Anderson"),
                                 Account(login:"trinity", password: "1", name:"Ms. Trinity"),
                                 Account(login:"morpheus", password: "1", name:"Mr. Morpheus")
                                ]
    }
    
    static func check(_ login: String, with password: String) -> Account? {
        for acc in Auth.ArrayProvider.users {
            if acc.login == login && acc.password == password {
                return acc
            }
        }
        return nil
    }
}
