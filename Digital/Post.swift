//
//  Post.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 4/15/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import Foundation


struct Post {
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
