//
//  MainTabBarController.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 3/30/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if FIRAuth.auth()?.currentUser == nil {
            print("User is nil")
            // lets us wait till the view is loaded and then presenting this.
                DispatchQueue.main.async {
                    let loginController = LoginController()
                    let navController = UINavigationController(rootViewController: loginController)
                    self.present(navController, animated: true, completion: nil)
            }
            
            return
        
        }
        

        setupViewControllers()
        self.tabBarController?.tabBar.tintColor = .blue
        self.tabBar.barTintColor = UIColor.rgb(red: 0, green: 0, blue: 0)
    }
    
    func setupViewControllers() {
 
        
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "homeunselected"), selectedImage: #imageLiteral(resourceName: "homeselected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "Searchunselected"), selectedImage: #imageLiteral(resourceName: "Searchselected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plusicon"), selectedImage: #imageLiteral(resourceName: "plusicon"))
        
        let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "Heartunselected"), selectedImage: #imageLiteral(resourceName: "heartselected"))
        
       //user profile
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
       
        
        
       
        
        viewControllers = [homeNavController, searchNavController, plusNavController, likeNavController, userProfileNavController]
        
        guard let items = tabBar.items else {return}
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
