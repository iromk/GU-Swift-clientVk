//
//  Image.swift
//  vkClient
//
//  Created by nnm on 11/6/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class VkImage : VkEntity {
    
    var uid: Int32 = 0

    var image: UIImage?
    var url: String?
    
    init(url: String) {
        self.url = url
    }
    
    func load(completion: @escaping (UIImage?) -> Void) {
        guard image == nil else { completion(self.image) ; return }

        Alamofire.request(self.url!)
                 .responseData { response in
                    guard let data = response.result.value else {  print("Problem loading image: (\(self.url!))"); return }
                    self.image = UIImage(data: data)
                    completion(self.image)
                  }
    }
}

/*
 photo_75
 string     url of the copy with maximum size of 75x75px.
 photo_130
 string     url of the copy with maximum size of 130x130px.
 photo_604
 string     url of the copy with maximum size of 604x604px.
 photo_807
 string     url of the copy with maximum size of 807x807px.
 photo_1280
 string     url of the copy with maximum size of 1280x1024px.
 photo_2560
 */
extension VkImage {

    convenience init(uid: Int32, url: String) {
        self.init(url: url)
        self.uid = uid
    }

}

class Photo : VkImage {
    
    enum Size : String { case xs = "photo_75", s = "photo_130", m = "photo_604",
                              l = "photo_807", xl = " photo_1280", xxl = "photo_2560" }
    
}

class Avatar : VkImage {
    
    enum Size : String { case s = "photo", m = "photo_medium", l = "photo_big" }
    
}
