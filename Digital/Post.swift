//
//  Post.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 4/15/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import Foundation


struct Post {
    
    let user: User
    let imageUrl: String
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
