//
//  FirebaseUtils.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 4/24/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import Firebase
import Foundation

extension FIRDatabase {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else {return }
            
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            
            //            self.fetchPostWithUser(user: user)
            
        }) { (error) in
            print("failed to fetch user:", error)
        }
    }
}
