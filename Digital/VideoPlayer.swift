//
//  VideoPlayer.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 5/13/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayer: UIViewController {
    
    
    
//    var selectedImage: URL? {
//        didSet {
//            self.videoUrl = selectedImage!
//        }
//    }
    
//    var videoUrl : URL
    
    let containerView :UIView = {
       let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 50, paddingBottom: 50, paddingRight: 50, width: 0, height: 0)
//
        view.backgroundColor = .white
  
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        
        self.containerView.layer.addSublayer(playerLayer)
        playerLayer.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        
        
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
        
    }
    

}
