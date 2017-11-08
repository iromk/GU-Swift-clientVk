//
//  VKDataProvider.swift
//  vkClient
//
//  Created by nnm on 11/5/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//
// загружает друзей на авторизованного пользователя,
// а друзей почти случайно выбранного id

import Foundation
import Alamofire
import SwiftyJSON
import WebKit

class VkApiProvider {
    
    var token: String?
    var uid: String?
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
    }
    
    func apiFriendsGet(onComplete: @escaping (JSON)->Void) {
        let params: Parameters = [
            "user_id": uid!,
            "access_token": token!,
            "v": "5.68"
        ]
        Alamofire.request(
            apiUrl + methodFriendsGet,
            method: .get,
            parameters: params)
            .validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("requesting friends...")
                    self.apiUsersGet(uids: json["response"]["items"], onComplete)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func apiUsersGet(uids: JSON, _ onComplete: @escaping (JSON)->Void) {
        let params: Parameters = [
            "user_ids": uids,
            "fields": "photo",
            "access_token": token!,
            "v": "5.68"
        ]
        Alamofire.request(
                    apiUrl + methodUsersGet,
                    method: .get,
                    parameters: params)
                .validate()
                .responseJSON
                    { response in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        onComplete(json)
                    case .failure(let error):
                        print(error)
                    }
                }
    }
    
}
