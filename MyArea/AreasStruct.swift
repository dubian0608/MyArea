//
//  Areas.swift
//  MyArea
//
//  Created by Zhang, Frank on 17/04/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import Foundation
import UIKit

struct AreasStruct {
    var name: String
    var province: String
    var part: String
    var image: UIImage
    var isVisted: Bool
    var rating: UIImage?
    
    init(name: String, province: String, part: String, image: UIImage, isVisted: Bool) {
        self.name = name
        self.province = province
        self.part = part
        self.image = image
        self.isVisted = isVisted
        self.rating = #imageLiteral(resourceName: "rating")
    }
}
