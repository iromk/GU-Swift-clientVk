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
    var friendsUids: JSON?

    let apiUrl = "https://api.vk.com"
    let methodFriendsGet = "/method/friends.get"
    let methodUsersGet = "/method/users.get"
    let methodPhotosGet = "/method/photos.getAll"

//    let testUid = "292290347"
    
    var jsonUserProfile: JSON?

    init(uid: String, with token: String) {
        self.token = token
        self.uid = uid
        requestUsersGet()
    }
    
    func getUserName() -> (String?, String?) {
        return (firstName , lastName )
    }
    
    func requestFriendsGet() {
        var params: Parameters = [
            "user_id": uid!,
            "access_token": token!,
            "v": "5.68"
        ]
        Alamofire.request(
            apiUrl + methodFriendsGet,
            method: .get,
            parameters: params)
            .responseData
            { response in
                self.onResponseFriendsGet(response) }
    }
    
    func requestUsersGet(uids: JSON) {
        var params: Parameters = [
            "user_ids": uids,
            "access_token": token!,
            "v": "5.68"
        ]
        
        Alamofire.request(
            apiUrl + methodUsersGet,
            method: .get,
            parameters: params)
            .responseData
            { response in
                self.onResponseFriendsGet(response) }
    }
    
    func requestUsersGet() {
        var params: Parameters = [
            "user_id": uid!,
            "access_token": token!,
            "v": "5.68"
        ]
        
        Alamofire.request(
                    apiUrl + methodUsersGet,
                    method: .get,
                    parameters: params)
                .responseData
                    { response in
                        self.onResponseUsersGet(response)
                        
                    }
        
    }
    
    func onResponseFriendsGet(_ response: DataResponse<Data>) {
        if let json = response.result.value {
//            print("JSON: \(json)") // serialized json response
        }
        
        do {
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
                jsonUserProfile = try JSON(data: (utf8Text.data(using: .utf8, allowLossyConversion: false))!)
            }
        }
        catch let e {
            print("Error catched \(e)")
        }
        print("test firendsUids names")

        if let _ = friendsUids { // already have friends uids
//            print(jsonUserProfile)
            print("got friends names")
            print(jsonUserProfile!["response"].arrayValue)
            var us = UserSession.getInstance()
            us.addFriends(json: jsonUserProfile!["response"])
            
        } else { // get them frist
            friendsUids = jsonUserProfile!["response"]["items"]
            print(friendsUids)
            requestUsersGet(uids: friendsUids!)
        }

//        lastName = jsonUserProfile!["response"][0]["last_name"].stringValue
//        firstName = jsonUserProfile!["response"][0]["first_name"].stringValue
    }
    
    func onResponseUsersGet(_ response: DataResponse<Data>) {
//        print("Request: \(String(describing: response.request))")   // original url request
//        print("Response: \(String(describing: response.response))") // http url response
//        print("Result: \(response.result)")                         // response serialization result
        
        if let json = response.result.value {
//            print("JSON: \(json)") // serialized json response
        }
        
        do {
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//            print("Data: \(utf8Text)") // original server data as UTF8 string
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
