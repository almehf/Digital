//
//  ViewController.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 3/26/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit
import Firebase


class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    let plusPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plusicon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    func handlePlusPhoto() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    
        
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let editedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 1, alpha: 1)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "username"
        tf.backgroundColor = UIColor(white: 1, alpha: 1)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "password"
        tf.backgroundColor = UIColor(white: 1, alpha: 1)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    func handleTextInputChange() {
        
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 &&
        usernameTextField.text?.characters.count ?? 0 > 0 &&
        passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            signUpButton.isEnabled = false
        }
    }
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    func handleSignUp() {
        
        guard let email = emailTextField.text, email.characters.count > 0 else { return }
        guard let username = usernameTextField.text, username.characters.count > 0 else { return }
        guard let password = passwordTextField.text, password.characters.count > 0 else { return }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            
            if let err = error {
                print("failed to create user:", err)
                return
            }
            
            print("Successfully created user:", user?.uid ?? "")
        
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            
            let filename = NSUUID().uuidString
            
            FIRStorage.storage().reference().child("profile_image").child(filename).put(uploadData, metadata: nil, completion: { (metadata, err) in
              
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                }
                
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                print("Successfully uploaded profile image:", profileImageUrl)
          
                /////
                guard let uid = user?.uid else { return }
                
                let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                let values = [uid: dictionaryValues]
                
                FIRDatabase.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if let err = err {
                        print("Failed to save user info into db:", err)
                        return
                    }
                    print("Successfully saved user info to db")
                    
                    let mainTabBarController = MainTabBarController()
                    self.present(mainTabBarController, animated: true, completion: nil)
                })
                
            })
          
        })
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        view.backgroundColor = UIColor(red:0.19, green:0.19, blue:0.19, alpha:1.0)
        
        view.addSubview(plusPhotoButton)
     
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       
        
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        
        setupInputFields()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: signUpButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton] )
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)


/*
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 200)
            ])
        
*/
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
        
        
        
    }
    
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Have an acount? ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Login", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    func handleAlreadyHaveAccount() {
        _ = navigationController?.popViewController(animated: true)
        print("WORKING")
    }
    
}

