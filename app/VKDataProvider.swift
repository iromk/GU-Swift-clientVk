//
//  VKDataProvider.swift
//  vkClient
//
//  Created by nnm on 11/5/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation
import  Alamofire
import SwiftyJSON

class VKDataProvider {
    
//    let token = "281e78ed311a75a5e6ed7c5dd8a5fea12f43e87747d2a718178ad5e65434108a7cf95ffa175f86b1e8e35"
    let token = "ec340580d1bf6f5596165ba88bc2e364d2751e766a45d4ceabdf56edff6f8d830951ef3dc4085c90ec8d2"
    
    let apiUrl = "https://api.vk.com"
    let methodFriendsGet = "/method/friends.get"
    let methodGetProfiles = "/method/getProfiles"
    let methodUserGet = "/method/user.get"
    let methodUsersGet = "/method/users.get"
    let methodPhotosGet = "/method/photos.getAll"

    let testUid = "292290347"
    var jsonUserProfile: JSON?

    func listFriends() {
        
        let params: Parameters = [
            "owner_id": testUid,
            "access_token": token,
//            "user_id": testUid,
//            "user_ids": "13178916,18111708,61006763",
            "v": "5.52"
        ]
        
        
        
        Alamofire.request(apiUrl + methodPhotosGet,
                          method: .get,
                          parameters: params)
                 .responseData
            { response in self.onResponse(response: response) }
//
    
//        let url2 = "https://oauth.vk.com/authorize?client_id=6247718&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&scope=friends&response_type=token&v=5.69"
//        Alamofire.request(url2, method: .get).responseData(completionHandler:
//            {
//                response in self.onResponse2(response: response) //print(response.value)
//
//        })
//


        
//        let authurl = "https://login.vk.com?act=login&soft=1&utf8=1"
//        let pr : Parameters = [
//            "pass": "7ynUFv9UHSRfu2xOAZGp",
//            "email": "+79011491774",
//            "to": "aHR0cHM6Ly9vYXV0aC52ay5jb20vYXV0aG9yaXplP2NsaWVudF9pZD02MjQ3NzE4JnJlZGlyZWN0X3VyaT1odHRwcyUzQSUyRiUyRm9hdXRoLnZrLmNvbSUyRmJsYW5rLmh0bWwmcmVzcG9uc2VfdHlwZT10b2tlbiZzY29wZT0yJnY9NS42OSZzdGF0ZT0mZGlzcGxheT1tb2JpbGU-",
//            "_origin": "https://oauth.vk.com",
//            "ip_h": "b6078ddecf7f97a6f2",
//            "lg_h": "8f241a9c45401ef405"
//        ]
//        Alamofire.request(authurl, method: .post, parameters: pr).responseData(completionHandler:
//                    {
//                        response in self.onResponse(response: response) //print(response.value)
//
//                })
    }
    
    func onResponse2(response: DataResponse<Data>)  {
        func matches(for regex: String, in text: String) -> [String] {
            
            do {
                let regex = try NSRegularExpression(pattern: regex)
                let results = regex.matches(in: text,
                                            range: NSRange(text.startIndex..., in: text))
                return results.map {
                    String(text[Range($0.range, in: text)!])
                }
            } catch let error {
                print("invalid regex: \(error.localizedDescription)")
                return []
            }
        }
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            let matched = matches(for: "([0-9a-f]{18})", in: utf8Text)
            print("--\(matched)--")
            let ip_h = matched[0]
            let lg_h = matched[1]

                    let authurl = "https://login.vk.com?act=login&soft=1&utf8=1"
                    let pr : Parameters = [
                        "pass": "7ynUFv9UHSRfu2xOAZGp",
                        "email": "+79011491774",
                        "to": "aHR0cHM6Ly9vYXV0aC52ay5jb20vYXV0aG9yaXplP2NsaWVudF9pZD02MjQ3NzE4JnJlZGlyZWN0X3VyaT1odHRwcyUzQSUyRiUyRm9hdXRoLnZrLmNvbSUyRmJsYW5rLmh0bWwmcmVzcG9uc2VfdHlwZT10b2tlbiZzY29wZT0yJnY9NS42OSZzdGF0ZT0mZGlzcGxheT1tb2JpbGU-",
                        "_origin": "https://oauth.vk.com",
                        "ip_h": ip_h,
                        "lg_h": lg_h
                    ]
                    Alamofire.request(authurl, method: .post, parameters: pr).responseData(completionHandler:
                                {
                                    response in self.onResponse(response: response) //print(response.value)
            
                            })
            
//            let matched2 = matches(for: "lg_h.*value=\"(.*)\"", in: utf8Text)
//            print("--\(matched2)--")
        }
//        ip_h.*value=\"(.*)\"

    }
    
    func onResponse(response: DataResponse<Data>) {
//        return
        print("Request: \(String(describing: response.request))")   // original url request
        print("Response: \(String(describing: response.response))") // http url response
        print("Result: \(response.result)")                         // response serialization result
        
        if let json = response.result.value {
            print("JSON: \(json)") // serialized json response
        }
        
        do {
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonUserProfile = try JSON(data: (utf8Text.data(using: .utf8, allowLossyConversion: false))!)
            }
        }
        catch let e {
            print("Error catched \(e)")
        }
        print("!!! \(jsonUserProfile!["response"][0]["last_name"].stringValue)")
        
    }
}
