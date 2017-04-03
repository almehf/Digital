//
//  LoginController.swift
//  Digital
//
//  Created by Nikolas Andryuschenko on 4/2/17.
//  Copyright © 2017 Andryuschenko. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    
    let logoContainerView: UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "iglogo"))
        logoImageView.backgroundColor = .red
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        
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
        
    //    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
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
    
    
    
    func handleLogin() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if email == "" || password == "" {
    
            print("ERROR")
            
        } else {
        
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if let error = error {
                    print(error)
                } else {
                }
                
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
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        
        setupInputFields()
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
    }
    
}
