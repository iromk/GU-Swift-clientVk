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
    var uid: UInt32?
    var friendsUids: JSON?

    let apiUrl = "https://api.vk.com"
    let methodFriendsGet = "/method/friends.get"
    let methodUsersGet = "/method/users.get"
    let methodPhotosGet = "/method/photos.getAll"
    let methodGroupsGet = "/method/groups.get"

//    let testUid = "292290347"
    
    var jsonUserProfile: JSON?

    init(uid: UInt32, with token: String) {
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
            "fields": "photo",
            "access_token": token!,
            "v": "5.68"
        ]
        makeRequest(methodFriendsGet, params, onComplete)
    }
    
    func apiUsersGet(uids: JSON, _ onComplete: @escaping (JSON)->Void) {
        let params: Parameters = [
            "user_ids": uids,
            "fields": "photo",
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
    
    func apiGroupsGet(uid: UInt32, _ onComplete: @escaping (JSON)->Void) {
        let params: Parameters = [
            "user_id": uid,
            "extended": "1",
            "access_token": token!,
            "v": "5.68"
        ]
        makeRequest(methodGroupsGet, params, onComplete)
    }
    
}
