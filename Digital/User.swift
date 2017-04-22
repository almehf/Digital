//
//  User.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 4/22/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct User {
        let username: String
        let profileImageUrl: String
        let phoneNumber: String
        
        init(dictionary: [String: Any]) {
            self.username = dictionary["username"] as? String ?? ""
            self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
            self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        }

}
    
