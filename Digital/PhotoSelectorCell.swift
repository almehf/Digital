//
//  PhotoSelectorCell.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 4/7/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit

class PhotoSelectorCell : UICollectionViewCell {
    
    let photoImageView: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .green
        
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
