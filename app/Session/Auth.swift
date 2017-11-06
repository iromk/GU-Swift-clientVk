//
//  Auth.swift
//  Homework01
//
//  Created by nnm on 10/26/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation

class Auth {



    struct ArrayProvider {
        struct Account {
            let login: String
            let password: String
            let name: String
        }
        static let users: [Account] = [ Account(login:"neo", password:"1", name:"Mr. Anderson"),
                                 Account(login:"trinity", password: "1", name:"Ms. Trinity"),
                                 Account(login:"morpheus", password: "1", name:"Mr. Morpheus")
                                ]
        static func check(_ login: String, with password: String) -> Account? {
            for acc in Auth.ArrayProvider.users {
                if acc.login == login && acc.password == password {
                    return acc
                }
            }
            return nil
        }
    }
    
    struct VkProvider {
        var authorizeUrl = URLComponents()
        
        init(forApp appid: String) {
            authorizeUrl.scheme = "https"
//            authorizeUrl.host = "vk.com"
            authorizeUrl.host = "oauth.vk.com"
            authorizeUrl.path = "/authorize"
            authorizeUrl.queryItems = [
                URLQueryItem(name: "client_id", value: appid),
                URLQueryItem(name: "display", value: "mobile"),
                URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                URLQueryItem(name: "scope", value: "262150"),
                URLQueryItem(name: "response_type", value: "token"),
                URLQueryItem(name: "v", value: "5.68")
            ]
        }
        
        
        func requestAuth() -> URLRequest {
            return URLRequest(url: authorizeUrl.url!)
        }
    }
    

}


