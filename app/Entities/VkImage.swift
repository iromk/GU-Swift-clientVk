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

class VkImage {
    
    var image: UIImage?
    var url: String?
    
    init(url: String) {
        self.url = url
    }
    
    func load(completion: @escaping (UIImage?) -> Void) {
        guard image == nil else { completion(self.image) ; return }

        Alamofire.request(self.url!)
                 .responseData { response in
                    guard let data = response.result.value else {                        print("Problem loading image"); return }
                    self.image = UIImage(data: data)
                    completion(self.image)
                  }
    }
}
