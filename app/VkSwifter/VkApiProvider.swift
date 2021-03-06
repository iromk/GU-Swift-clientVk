//
//  VKDataProvider.swift
//  vkClient
//
//  Created by Roman Syrchin on 11/5/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import WebKit

class VkApiProvider {
    
    var token: String?
    var uid: Vk.Uid?

    let apiUrl = "https://api.vk.com"
    let methodFriendsGet = "/method/friends.get"
    let methodUsersGet = "/method/users.get"
    let methodPhotosGet = "/method/photos.getAll"
    let methodGroupsGet = "/method/groups.get"

    init(uid: Vk.Uid, with token: String) {
        self.token = token
        self.uid = uid
    }
    
    func makeRequest(_ method: String, _ params: Parameters, _ onComplete: @escaping (JSON)->Void) {
        Alamofire.request(
            apiUrl + method,
            method: .get,
            parameters: params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    onComplete(json)
                case .failure(let error):
                    print(error)
                }
        }
    }

    func apiFriendsGet(onComplete: @escaping (JSON)->Void) {
        let params: Parameters = [
            "user_id": uid!,
            "fields": Avatar.Size.S.rawValue,
            "access_token": token!,
            "v": "5.68"
        ]
        makeRequest(methodFriendsGet, params, onComplete)
    }
    
    func apiUsersGet(uids: JSON, _ onComplete: @escaping (JSON)->Void) {
        let params: Parameters = [
            "user_ids": uids,
            "fields": Avatar.Size.S.rawValue,
            "access_token": token!,
            "v": "5.68"
        ]
        makeRequest(methodUsersGet, params, onComplete)
    }
    
    func apiPhotosGet(owned friend: Friend, _ onComplete: @escaping (JSON)->Void) {
        let params: Parameters = [
            "owner_id": friend.uid,
            "album_id": "profile",
            "access_token": token!,
            "v": "5.68"
        ]
        makeRequest(methodPhotosGet, params, onComplete)
    }
    
    func apiGroupsGet(uid: Vk.Uid, _ onComplete: @escaping (JSON)->Void) {
        let params: Parameters = [
            "user_id": uid,
            "extended": "1",
            "access_token": token!,
            "v": "5.68"
        ]
        makeRequest(methodGroupsGet, params, onComplete)
    }
    
}
