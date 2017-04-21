//
//  HomeController.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 4/21/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
    
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItems()
        
        fetchPosts()
    }
    
    func setupNavigationItems() {
        navigationItem.title = "Home"
    }
 
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    var posts = [Post]()
    fileprivate func fetchPosts() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        let ref = FIRDatabase.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value)
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                //print("Key \(key), Value: \(value)")
                
                guard let dictionary = value as? [String: Any] else { return }
                
                let post = Post(dictionary: dictionary)
                self.posts.append(post)
            })
            
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
        
    }
    
}
