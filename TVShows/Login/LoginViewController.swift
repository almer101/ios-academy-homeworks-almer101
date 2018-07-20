//
//  LoginViewController.swift
//  TVShows
//
//  Created by Ivan Almer on 11/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import CodableAlamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    private let pinkColor = UIColor(red: 255.0/255.0, green: 117.0/255.0, blue: 140.0/255.0, alpha: 1)
    private let lightGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    private var user: User? = nil
    private var currentUserData: UserData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        loginButton.backgroundColor = pinkColor
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        
        rememberMeButton.setTitleColor(pinkColor, for: .normal)
    }

    func getLoginInputData() -> [String:String] {
        var parameters: [String:String] = [:]
        
        if let email = usernameTextField.text,
            let pass = passwordTextField.text,
            !email.isEmpty, !pass.isEmpty {
            
            parameters["email"] = email
            parameters["password"] = pass
        }
        return parameters
    }
    
    func alertUser() {
        let alert = UIAlertController(title: "Wrong entry", message: "Please check all the fields", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loginUser(userData: UserData) {
        LoginApiClient.shared.loginUser(userData: userData, onSuccess: { (loginData) in
            self.currentUserData = userData
            guard let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
                return
            }
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}

extension LoginViewController {
    
    @IBAction func loginAction(_ sender: UIButton) {
        let params = getLoginInputData()
        if params.count == 0 {
            alertUser()
            return
        }
        let userData = UserData(email: params["email"]!, password: params["password"]!)
        loginUser(userData: userData)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        let params = getLoginInputData()
        if params.count == 0 {
            alertUser()
            return
        }
        let userData = UserData(email: params["email"]!, password: params["password"]!)
        
        LoginApiClient.shared.registerUser(userData: userData, onSuccess: { (user) in
            self.user = user
            self.loginUser(userData: userData)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}
