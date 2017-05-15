//
//  SharePhotoController.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 4/11/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Firebase
import AVKit
import AVFoundation

class SharePhotoController : UIViewController {
    
    
    static var postIsPosted = false
    
    var selectedImage: UIImage? {
        didSet {
                self.imageView.image = selectedImage
        }
    }
    
    var urlString = ""
    
    var selectedVideoUrl: String? {
        didSet {
            self.urlString = selectedVideoUrl!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleVideoSelectedForUrl))
    
        setupImageAndTextViews()
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    fileprivate func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white

        view.addSubview(containerView)
        
        //toplayoutguide is the highest verical extent.
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        containerView.addSubview(bubbleView)
        bubbleView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
//        bubbleView.addSubview(imageView)
//        bubbleView.anchor(top: bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 0)
//        
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: bubbleView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        imageView.isHidden = true
        
        let videoURL = URL(string: urlString)
        
        player = AVPlayer(url: videoURL!)
        
        playerLayer = AVPlayerLayer(player: player)
        
        bubbleView.layer.addSublayer(playerLayer!)
        playerLayer?.frame = CGRect(x: 0, y: 0, width: 84, height: 84)
        
//        playerLayer?.frame = view.bounds
//        view.layer.addSublayer(playerLayer!)
        
        player?.play()
//        activityIndicatorView.startAnimating()
//        playButton.isHidden = true
        
        print("Attempting to play video......???")
    
    
    }
    
    
    
    func handleShare() {
        guard let image = selectedImage else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // random string
        let filename = NSUUID().uuidString
        FIRStorage.storage().reference().child("posts").child(filename).put(uploadData, metadata: nil) { (metadata, error) in
            
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post to image:", error)
            }
            
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
            self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
        }
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        
        guard let caption = textView.text else { return }
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let userPostRef = FIRDatabase.database().reference().child("posts").child(uid)
        
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWithd": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("failed to save to database", error)
                return
            }
                print("successfully saved post to databates")
            
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            
               NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName , object: nil)

        }
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    
    
    @objc fileprivate func handleVideoSelectedForUrl() {
        let url = URL(string: urlString)
        let filename = UUID().uuidString + ".mov"
        let uploadTask = FIRStorage.storage().reference().child("message_movies").child(filename).putFile(url!, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                print("Failed upload of video:", error)
                return
            }
            
            
            guard let videoUrl = metadata?.downloadURL()?.absoluteString else { return }
            self.saveToDatabaseWithVideoUrl(videoUrl: videoUrl)
            
            //            if let videoUrl = metadata?.downloadURL()?.absoluteString {
            //                if let thumbnailImage = self.thumbnailImageForFileUrl(url) {
            //
            //                    self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
            //                        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": videoUrl as AnyObject]
            //                        self.sendMessageWithProperties(properties)
            //
            //                    })
            //                }
            
            print("videoUrl is the following", videoUrl)
            //            }
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            //            self.navigationItem.title = self.user?.name
        }
    }
    
    
    fileprivate func saveToDatabaseWithVideoUrl(videoUrl: String) {
        guard let postImage = selectedImage else { return }
        
        guard let caption = textView.text else { return }
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let userPostRef = FIRDatabase.database().reference().child("posts").child(uid)
        
        let ref = userPostRef.childByAutoId()
        
        let values = ["videoUrl": videoUrl, "caption": caption, "imageWithd": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("failed to save to database", error)
                return
            }
            print("successfully saved post to databates")
            
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName , object: nil)
            
        }
        
    }

    
    
}
