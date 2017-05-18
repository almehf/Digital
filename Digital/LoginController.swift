//
//  LoginController.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 4/2/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import DigitsKit

class LoginController: UIViewController {
    
    let logoContainerView: UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "DIGITAL"))

        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor = UIColor.rgb(red: 33, green: 33, blue: 33)
        
        return view
    }()
    
    
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 1, alpha: 1)
        tf.borderStyle = .roundedRect
       // tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.font = UIFont.systemFont(ofSize: 14)
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
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an acount? ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    
    func handleTextInputChange() {
        
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 &&
            passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            loginButton.isEnabled = false
        }
    }
    
    
    
    func handleLogin() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if email == "" || password == "" {
    
            print("ERROR")
            
        } else {
        
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if let error = error {
                    print("Failed to sign in with email:", error)
                }
                
                print("Successfully loggeed back in with user:", user?.uid ?? "")
                guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                mainTabBarController.setupViewControllers()
                self.dismiss(animated: true, completion: nil)
                
            })
            
        }
        
    }
    
    func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 33, green: 33, blue: 33)
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        
        setupInputFields()
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
       


    }
    
    
    var users = [User]()
    fileprivate func setupInputFields() {
        
        let authenticateButton = DGTAuthenticateButton { session, error in
            if let phoneNumber = session?.phoneNumber {
                // TODO: associate the session userID with your user model
                let message = "Phone number: \(phoneNumber)"
                print("THIS IS THE PHOEN NUMBER", phoneNumber)
//                let alertController = UIAlertController(title: "You are logged in!", message: message, preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
//                self.present(alertController, animated: true, completion: .none)
               
                let ref = FIRDatabase.database().reference().child("users")
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let dictionaries = snapshot.value as? [String: Any] else {return }
                    
                    dictionaries.forEach({ (key, value) in
                        print(key, value)
                        
                        guard let userDictionary = value as? [String: Any] else { return }
                        
                        
                        let user = User(uid: key, dictionary: userDictionary)
                        print(user.uid, user.username)
                        
                        self.users.append(user)
                        
                        if ("+1\(user.phoneNumber)") == phoneNumber{
                            print("SUCCESS")
                            
                            
                            FIRAuth.auth()?.signIn(withEmail: user.email, password: user.password, completion: { (user, error) in
                                
                                if let error = error {
                                    print("Failed to sign in with email:", error)
                                }
                                
                                print("Successfully loggeed back in with user:", user?.uid ?? "")
                                guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                                mainTabBarController.setupViewControllers()
                                self.dismiss(animated: true, completion: nil)
                                
                            })
                            
                        } else {
                            print("NAH")
                        }
                        
                        
                        //                if user.phoneNumber == PHONE_NUMBER {
                        //                    FIRAuth.auth()?.signIn(withEmail: user.email, password: user.password, completion: <#T##FIRAuthResultCallback?##FIRAuthResultCallback?##(FIRUser?, Error?) -> Void#>)
                        //                }
                        
                        //                let uservalue = "Test1"
                        //                if uservalue == "\(user.username)" {
                        //                    print("uservalue printed")
                        //                    print(user.profileImageUrl)
                        //                }
                        //
                    })
                    
                })
                
                
                
            } else {
                NSLog("Authentication error: %@", error!.localizedDescription)
            }
        }
        
        func fetchUsers() {
            
            let ref = FIRDatabase.database().reference().child("users")
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionaries = snapshot.value as? [String: Any] else {return }
                
                dictionaries.forEach({ (key, value) in
                    print(key, value)
                    
                    guard let userDictionary = value as? [String: Any] else { return }
                    
                    
                    let user = User(uid: key, dictionary: userDictionary)
                    print(user.uid, user.username)
                    
                    self.users.append(user)
                    
                    //                if user.phoneNumber == PHONE_NUMBER {
                    //                    FIRAuth.auth()?.signIn(withEmail: user.email, password: user.password, completion: <#T##FIRAuthResultCallback?##FIRAuthResultCallback?##(FIRUser?, Error?) -> Void#>)
                    //                }
                    
                    //                let uservalue = "Test1"
                    //                if uservalue == "\(user.username)" {
                    //                    print("uservalue printed")
                    //                    print(user.profileImageUrl)
                    //                }
                    //
                })
                
            })
        }

        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, authenticateButton!])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
    
    
        
       
    
        
    }
    
}
