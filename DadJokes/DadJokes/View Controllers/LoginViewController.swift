//
//  LoginViewController.swift
//  DadJokes
//
//  Created by Thomas Cacciatore on 6/3/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    
    var jokeController = JokeController()
    var signInType: SignInType = .signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
    
    }
    
    func assignbackground(){
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    @IBAction func signInTypeChanged(_ sender: Any) {
        if loginTypeSegmentedControl.selectedSegmentIndex == 0 {
            signInType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            signInType = .logIn
            signInButton.setTitle("Log In", for: .normal)
        }
    }
    
    @IBAction func authenticate(_ sender: Any) {
        
//        guard let username = usernameTextField.text,
//            let password = passwordTextField.text else { return }
        
        switch signInType {
            
        case .signUp:
            
            print("not using signUp right now")
            
//            jokeController?.signUp(with: username, password: password, completion: { (error) in
//
//                if let error = error {
//                    NSLog("Error signing up: \(error)")
//                } else {
//                    DispatchQueue.main.async {
//                        let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
//                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                        alertController.addAction(alertAction)
//                        self.present(alertController, animated: true, completion: {
//                            self.signInType = .logIn
//                            self.loginTypeSegmentedControl.selectedSegmentIndex = 1
//                            self.signInButton.setTitle("Sign In", for: .normal)
//                        })
//                    }
//                }
//            })
            
        case .logIn:
            

            jokeController.getToken()
            
            navigationController?.popViewController(animated: true)

//            jokeController.logIn(with: username, password: password, completion: { (error) in
//                if let error = error {
//                    NSLog("Error logging in: \(error)")
//                } else {
//                    DispatchQueue.main.async {

//                        self.navigationController?.popViewController(animated: true)

//                    }
//                }
//            })
        }
    }
    
    enum SignInType {
        case signUp
        case logIn
    }
}


