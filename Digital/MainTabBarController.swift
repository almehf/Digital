//
//  MainTabBarController.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 3/30/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        
        let navController = UINavigationController(rootViewController: userProfileController)
     
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")

        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
        
    }
}
