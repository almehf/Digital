//
//  PreviewPhotoContainerView.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 5/11/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageView: UIImageView = {
       let iv = UIImageView()
        return iv
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveButon: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    func handleSave() {
        
        let library = PHPhotoLibrary.shared()
        
        guard let previewImage = previewImageView.image else { return }
        
        library.performChanges({ 
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, error) in
            if let error = error {
                print("Failed to save image to photo library:", error)
                return
            }
            print("SUCCESSFULLY SAVED IMAGE")
        
            DispatchQueue.main.async {
                
            
            let savedLabel = UILabel()
            savedLabel.text = "Saved Succesffully"
            savedLabel.textColor = .white
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
            savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
            
            savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
            savedLabel.center = self.center
                savedLabel.numberOfLines = 0
                
                
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (completed) in
                    
                    
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                    }, completion: { (_) in
                        savedLabel.removeFromSuperview()
                    
                })
            
            
             })
            self.addSubview(savedLabel)
        
                
            }
    }
    
    }
    
    func handleCancel(){
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        addSubview(saveButon)
        saveButon.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
