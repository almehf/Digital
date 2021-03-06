//
//  UserProfileHeader.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 3/31/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader: UICollectionViewCell {
    
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            
            usernameLabel.text = user?.username
            
            setupEditFollowButton()
        
        }
    }
    

    
    fileprivate func setupEditFollowButton() {
        guard let currentLoggedInUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            //edit profile
            
                let followingRef = FIRDatabase.database().reference().child("following").child(currentLoggedInUserId)
                
                followingRef.observe(.value, with: { (snapshot) in
                    self.followingLabel.text = "\(snapshot.childrenCount)"
                }) { (err) in
                    
                }
        
            let followersRef = FIRDatabase.database().reference().child("followers").child(currentLoggedInUserId)
            
            followersRef.observe(.value, with: { (snapshot) in
                self.followersLabel.text = "\(snapshot.childrenCount)"
            }) { (err) in
                
            }
            
            let postsRef = FIRDatabase.database().reference().child("posts").child(currentLoggedInUserId)
            
            postsRef.observe(.value, with: { (snapshot) in
                self.postsLabel.text = "\(snapshot.childrenCount)"
            }) { (err) in
                
            }
            
        } else {
            
            let followingRef = FIRDatabase.database().reference().child("following").child(userId)
            
            followingRef.observe(.value, with: { (snapshot) in
                self.followingLabel.text = "\(snapshot.childrenCount)"
            }) { (err) in
                
            }
            
            let followersRef = FIRDatabase.database().reference().child("followers").child(userId)
            
            followersRef.observe(.value, with: { (snapshot) in
                self.followersLabel.text = "\(snapshot.childrenCount)"
            }) { (err) in
                
            }
            
            let postsRef = FIRDatabase.database().reference().child("posts").child(userId)
            
            postsRef.observe(.value, with: { (snapshot) in
                self.postsLabel.text = "\(snapshot.childrenCount)"
            }) { (err) in
                
            }
            
            
            // check if following
            FIRDatabase.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                    
                } else {
                    self.setupFollowStyle()
                }
                
            }, withCancel: { (err) in
                print("Failed to check if following:", err)
            })
        }
    }
    
    func handleEditProfileOrFollow() {
        print("Execute edit profile / follow / unfollow logic...")
        
        guard let currentLoggedInUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            
            //unfollow
            FIRDatabase.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue(completionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user:", err)
                    return
                }
                
                print("Successfully unfollowed user:", self.user?.username ?? "")
                
                self.setupFollowStyle()
            })
           
            //unfollowers
            FIRDatabase.database().reference().child("followers").child(userId).child(currentLoggedInUserId).removeValue(completionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user:", err)
                    return
                }
                
                print("Successfully unfollowed user:", self.user?.username ?? "")
                
            })
            
            
        } else {
            //follow
            let ref = FIRDatabase.database().reference().child("following").child(currentLoggedInUserId)
            
            let values = [userId: 1]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to follow user:", err)
                    return
                }
                
                print("Successfully followed user: ", self.user?.username ?? "")
                
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = .white
                self.editProfileFollowButton.setTitleColor(.black, for: .normal)
            }
        
        //followers
            let followersRef = FIRDatabase.database().reference().child("followers").child(userId)
            let followersValues = [currentLoggedInUserId: 1]
            followersRef.updateChildValues(followersValues) { (err, ref) in
                if let err = err {
                    print("Failed to follow user:", err)
                    return
                }
              
            }
        }
    }
    
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        return iv
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "gridselected"), for: .normal)
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        
        return button
    }()
    
    func handleChangeToGridView() {
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        gridButton.tintColor = .mainBlue()
        delegate?.didChangeToGridView()
        
    }
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    func handleChangeToListView() {
        listButton.tintColor = .mainBlue()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToListView()
    }
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    
    var postsLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0

        return label
    }()
    
    
    let postsLabelText: UILabel = {
        let label = UILabel()
        label.text = "posts"
        label.textColor = .white
         label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    let followersLabelText: UILabel = {
        let label = UILabel()
        label.text = "followers"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let followingLabelText: UILabel = {
        let label = UILabel()
        label.text = "following"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
         return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
         return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        setupBottomToolbar()
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        setupUserStatsView()
        
       
        
    }
    
    fileprivate func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 20)
        /*
        let textStackView = UIStackView(arrangedSubviews: [postsLabelText, postsLabelText, postsLabelText])
        textStackView.distribution = .fillEqually
        addSubview(textStackView)
        textStackView.anchor(top: stackView.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
 */
        
        addSubview(postsLabelText)
        postsLabelText.centerXAnchor.constraint(equalTo: postsLabel.centerXAnchor).isActive = true
        postsLabelText.topAnchor.constraint(equalTo: postsLabel.bottomAnchor).isActive = true
   
        addSubview(followersLabelText)
        followersLabelText.centerXAnchor.constraint(equalTo: followersLabel.centerXAnchor).isActive = true
        followersLabelText.topAnchor.constraint(equalTo: followersLabel.bottomAnchor).isActive = true
   
        addSubview(followingLabelText)
        followingLabelText.centerXAnchor.constraint(equalTo: followingLabel.centerXAnchor).isActive = true
        followingLabelText.topAnchor.constraint(equalTo: followingLabel.bottomAnchor).isActive = true
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: followersLabelText.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
        
    }
    
    fileprivate func setupBottomToolbar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}


