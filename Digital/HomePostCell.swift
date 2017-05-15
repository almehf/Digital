//
//  HomePostCell.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 4/21/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

protocol HomePostCellDelegate {
    func didTapComment(post: Post)
}

class HomePostCell: UICollectionViewCell {
 
    var delegate : HomePostCellDelegate?
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else {return}
            photoImageView.loadImage(urlString: postImageUrl)

            usernameLabel.text = post?.user.username
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            
            userProfileImageView.loadImage(urlString: profileImageUrl)
            captionLabel.text = post?.caption
            
            
            guard let videoStringUrl = post?.videoUrl else { return}
            videoUrl = videoStringUrl
            
            setupAttributedCaption()
        }
    }

    var videoUrl = ""
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "\(post.caption)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.gray]))
        captionLabel.attributedText = attributedText
    }
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .blue
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
       
        let label = UILabel()
        label.text  = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    lazy var optionsButton: UIButton = {
       
        let button = UIButton()
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "Heartunselected").withRenderingMode(.alwaysTemplate), for: .normal)
         button.tintColor = .white
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
  
        return button
    }()
    
    lazy var sendToButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let captionLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 0
         label.textColor = .white
        return label
    }()
    
    let containerView :UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupPlayer() {
        
        let videoToPlay = URL(string: videoUrl)
        let player = AVPlayer(url: videoToPlay!)
        let playerLayer = AVPlayerLayer(player: player)
        
        self.photoImageView.layer.addSublayer(playerLayer)

        playerLayer.frame = self.bounds
        player.play()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
  
//        setupMainView()
        
        setupMainView()
        setupActionButtons()
        
        if videoUrl != "" {
                setupPlayer()
        }
    }
    
    
    func setupMainView() {
    addSubview(userProfileImageView)
    addSubview(usernameLabel)
    addSubview(optionsButton)
    addSubview(photoImageView)
    
    userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
    userProfileImageView.layer.cornerRadius = 40/2
    
    usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: optionsButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    optionsButton.anchor(top: topAnchor, left: nil, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 0)
    
    photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    
    }
    
    func handleComment() {
        guard let post = post else {return}
        delegate?.didTapComment(post: post)
    }
    
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendToButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
        
        
        addSubview(bookmarkButton)
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 50)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
