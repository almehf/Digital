//
//  Comment.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 5/18/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import Foundation


struct Comment {
    
    let user: User
    
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
