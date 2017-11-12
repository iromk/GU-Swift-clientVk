//
//  Image.swift
//  vkClient
//
//  Created by Roman Syrchin on 11/6/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift

struct Vk {
    
}



class VkImage : Object, VkEntity {
    
    @objc dynamic var uid: Vk.Uid = 0

//    @objc
    var image: UIImage? {
        get {
            let imageFileName = self.uid
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(imageFileName).jpg")
            guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
            return UIImage(contentsOfFile: fileURL.path)
        }
    }
//    @objc dynamic
//    var imagePath: String?
//    let image: UIImage {
//        get {
//            return UIImage(contantsFromFile:)
//            NSTemporaryDirectory()
//        }
//    }
    @objc dynamic
    var url: String?
    
//    override static func primaryKey() -> String? {
//        return "uid"
//    }

    convenience init(url: String, uid: Vk.Uid) {
        self.init()
        self.uid = uid
        self.url = url
    }
    
    func load(completion: @escaping (UIImage?) -> Void) {
        let imageFileName = self.uid
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(imageFileName).jpg")
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in return (fileURL, [.removePreviousFile]) }
        
//        print("exists? \(uid) from \(url) to \(fileURL.path)")
        let exists = FileManager.default.fileExists(atPath: fileURL.path)
//        print("exists \(exists)")
        guard FileManager.default.fileExists(atPath: fileURL.path) == false else { completion(self.image) ; return }
//        guard let _ = image else { completion(self.image) ; return }
//        print("not exists - loading image \(uid) from \(url) to \(fileURL.path)")
//        Alamofire.request(self.url!)
        Alamofire.download(self.url!, to: destination)
//            .responseData { response in
                 .response { response in
//                    Alamofire.download(urlString).responseData { response in
//                        print("Temporary URL: \(response.temporaryURL)\n\(NSTemporaryDirectory())")
//                    }
                    let exists = FileManager.default.fileExists(atPath: fileURL.path)
                    print("exists \(exists)")
//                    if let imagePath1 = response.destinationURL?.path {
//                        print("let image = UIImage(contentsOfFile: \(imagePath1))")
//                        print("exists \(FileManager.default.fileExists(atPath: imagePath1))")
//                    }
//                    guard let data = response.result.value else {  print("Problem loading image: (\(self.url!))"); return }
//                    let destination = DownloadRequest.suggestedDownloadDestination(for: NS)
//                    self.image = UIImage(data: data)
//                    print("loaded image \(self.uid) from \(self.url), \(self.image)")
                    completion(self.image)
                  }
    }
}

/*
 file:///Users/nnm/Library/Developer/CoreSimulator/Devices/37C9BA3E-6933-4740-AC18-1BF026A58C24/data/Containers/Data/Application/78D6ABB1-0B80-42B1-AFE7-EE673D64F909/tmp/156384838.jpg
        /Users/nnm/Library/Developer/CoreSimulator/Devices/37C9BA3E-6933-4740-AC18-1BF026A58C24/data/Containers/Data/Application/78D6ABB1-0B80-42B1-AFE7-EE673D64F909/tmp/156384838.jpg)
 */
    

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
    
    enum Size : String { case xs = "photo_75", s = "photo_130", m = "photo_604",
                              l = "photo_807", xl = " photo_1280", xxl = "photo_2560" }
    
}

class Avatar : VkImage {
    
    enum Size : String { case s = "photo", m = "photo_medium", l = "photo_big" }
    
    convenience init(url: String, of uid: Vk.Uid) {
        self.init(url: url, uid: uid)
//        self.uid = uid
//        self.url = url
    }

}
