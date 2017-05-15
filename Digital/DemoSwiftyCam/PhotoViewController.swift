
import UIKit
import Photos

class PhotoViewController: UIViewController {

	override var prefersStatusBarHidden: Bool {
		return true
	}

	private var backgroundImage: UIImage

	init(image: UIImage) {
		self.backgroundImage = image
        previewImageView.image = backgroundImage
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    
    let saveButton :UIButton = {
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "save_shadow"), for: .normal)
        
        button.addTarget(self, action: #selector(download), for: .touchUpInside)
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        return button
    }()
    
    func handleNextButton() {
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = previewImageView.image
        let navController = UINavigationController(rootViewController: sharePhotoController)
       
        self.present(navController, animated: true, completion: nil)
        
        }
    
    
    
    
    let previewImageView = UIImageView()
    
    
    
    func download() {
        
            
            guard let previewImage = previewImageView.image else { return }
            
            let library = PHPhotoLibrary.shared()
            library.performChanges({
                
                PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
                
            }) { (success, err) in
                if let err = err {
                    print("Failed to save image to photo library:", err)
                    return
                }
                
                print("Successfully saved image to library")
                
                DispatchQueue.main.async {
                    let savedLabel = UILabel()
                    savedLabel.text = "Saved Successfully"
                    savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                    savedLabel.textColor = .white
                    savedLabel.numberOfLines = 0
                    savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                    savedLabel.textAlignment = .center
                    
                    savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                    savedLabel.center = self.view.center
                    
                    self.view.addSubview(savedLabel)
                    
                    savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                        
                    }, completion: { (completed) in
                        //completed
                        
                        UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                            
                            savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                            savedLabel.alpha = 0
                            
                        }, completion: { (_) in
                            
                            savedLabel.removeFromSuperview()
                            
                        })
                        
                    })
                }
                
            }
        }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        if SharePhotoController.postIsPosted == true {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//    
//    
//    override func viewDidAppear(_ animated: Bool) {
////        super.viewDidAppear(true)
//        if SharePhotoController.postIsPosted == true {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        
        
		self.view.backgroundColor = UIColor.gray
		let backgroundImageView = UIImageView(frame: view.frame)
		backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
		backgroundImageView.image = backgroundImage
		view.addSubview(backgroundImageView)
		view.addSubview(cancelButton)
        cancelButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        view.addSubview(saveButton)
        saveButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 80, height: 80)
        
        view.addSubview(nextButton)
        nextButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 100, height: 100)
        
	}

	func cancel() {
		dismiss(animated: true, completion: nil)
	}
}
