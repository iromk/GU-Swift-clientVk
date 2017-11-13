//
//  Image.swift
//  Defines classes:
//    - VkImage
//    - Avatar : VkImage
//    - Photo : VkImage
//
//  Created by Roman Syrchin on 11/6/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift

class VkImage : Object, VkEntity {
    
    @objc dynamic var uid: Vk.Uid = 0

    func fileUrl() -> URL {
        let imageFileName = self.uid
        return FileManager.default.temporaryDirectory.appendingPathComponent("\(imageFileName).jpg")
    }
    
    var image: UIImage? {
        get {
            let filePath = fileUrl().path
            guard FileManager.default.fileExists(atPath: filePath) else { return nil }
            return UIImage(contentsOfFile: filePath)
        }
    }

    @objc dynamic
    var url: String?
    
    convenience init(url: String, uid: Vk.Uid) {
        self.init()
        self.uid = uid
        self.url = url
    }
    
    func load(completion: @escaping (UIImage?) -> Void) {
        let fileUrl = self.fileUrl()
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in return (fileUrl, [.removePreviousFile]) }

        let exists = FileManager.default.fileExists(atPath: fileUrl.path)
        guard exists == false else { completion(self.image) ; return }
        Alamofire.download(self.url!, to: destination)
                 .response { response in
                    completion(self.image) // image getter will check if file actually exists
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

    convenience init(uid: Vk.Uid, url: String) {
        self.init(url: url, uid: uid)
        self.uid = uid
    }

}

class Photo : VkImage {
    
    enum Size : String { case XS = "photo_75", S = "photo_130", M = "photo_604",
                              L = "photo_807", XL = " photo_1280", XXL = "photo_2560" }
    
}

class Avatar : VkImage {
    
    enum Size : String { case S = "photo"; case M = "photo_medium"; case L = "photo_big" }
    
    convenience init(url: String, of uid: Vk.Uid) {
        self.init(url: url, uid: uid)
    }

}
