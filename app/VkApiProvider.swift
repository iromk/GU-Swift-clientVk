//
//  VKDataProvider.swift
//  vkClient
//
//  Created by nnm on 11/5/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import WebKit

class VkApiProvider {
    
    var token: String?
    var uid: String?
    var firstName: String?
    var lastName: String?
    

    let apiUrl = "https://api.vk.com"
    let methodFriendsGet = "/method/friends.get"
    let methodUsersGet = "/method/users.get"
    let methodPhotosGet = "/method/photos.getAll"

//    let testUid = "292290347"
    
    var jsonUserProfile: JSON?

    init(uid: String, with token: String) {
        self.token = token
        self.uid = uid
        requestUsersGet(uids: nil)
    }
    
    func getUserName() -> (String?, String?) {
        
        return (firstName ?? "User", lastName ?? "Name")
    }
    
    func requestUsersGet(uids: String?) {
        print("token3: [\(token)]")
        var params: Parameters = [
            "user_id": uid!,
            "access_token": token!,
            "v": "5.68"
        ]
        if let _ = uids {
            params["user_ids"] = uids
        }
        
        Alamofire.request(
                    apiUrl + methodUsersGet,
                    method: .get,
                    parameters: params)
                .responseData
                    { response in
                        self.onResponseUsersGet(response) }
    }

        /*
         https://login.vk.com/?act=logout&amp;hash=6ab0d5ee8d63f88d4d&amp;reason=tn&amp;_origin=https://vk.com
         */
    /*
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
            { response in self.onResponse(response) }
    
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
    */
    
    func onResponseUsersGet(_ response: DataResponse<Data>) {
//        print("Request: \(String(describing: response.request))")   // original url request
//        print("Response: \(String(describing: response.response))") // http url response
//        print("Result: \(response.result)")                         // response serialization result
        
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
        lastName = jsonUserProfile!["response"][0]["last_name"].stringValue
        firstName = jsonUserProfile!["response"][0]["first_name"].stringValue

    }
}
