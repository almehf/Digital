//
//  MainTabBarController.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 3/30/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FIRAuth.auth()?.currentUser == nil {
            
            // lets us wait till the view is loaded and then presenting this.
                DispatchQueue.main.async {
                    let loginController = LoginController()
                    let navController = UINavigationController(rootViewController: loginController)
                    self.present(navController, animated: true, completion: nil)
            }
            return
        
        }
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        
        let navController = UINavigationController(rootViewController: userProfileController)
     
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")

        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
        
    }
}
