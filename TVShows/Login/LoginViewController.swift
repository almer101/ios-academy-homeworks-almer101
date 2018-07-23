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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    private var user: User? = nil
    private var currentUserData: UserData? = nil
    private var activeField: UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        addDelegateToTextFields()
        setupUI()
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil,
                                               queue: nil) { [weak self] (notification) in
                                                
//                                                    if let keyboardSize = ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]) as? NSValue)?.cgRectValue {
//                                                        let keyboardHeight = keyboardSize.height
//                                                        UIView.animate(withDuration: 0.3, animations: {
//                                                            self?.contentView.frame.size.height -= keyboardHeight
//                                                        })
//                                                        let distanceToBottom = (self?.scrollView.frame.size.height)! - (self?.activeField?.frame.origin.y)! - (self?.activeField?.frame.size.height)!
//                                                        let collapseSpace = keyboardHeight - distanceToBottom
////                                                        if collapseSpace < 0 { return }
//                                                        UIView.animate(withDuration: 0.3, animations: {
//                                                            // scroll to the position above keyboard 10 points
//                                                            self?.scrollView.contentOffset = CGPoint(x: 0, y: -(keyboardHeight - (self?.passwordTextField.frame.origin.y)! - (self?.passwordTextField.frame.size.height)!))
//                                                        })
//                                                }
                                                }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil,
                                               queue: nil) { [weak self] (notification) in
                                                    if let _ = ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]) as? NSValue)?.cgRectValue {
                                                        
                                                    }
                                                }
    }
    
    func addDelegateToTextFields() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func setupUI() {
        loginButton.backgroundColor = UIColor.tvShowsPink
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        
        rememberMeButton.setTitleColor(UIColor.tvShowsPink, for: .normal)
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
    
    func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func loginUser(userData: UserData) {
        ShowsApiClient.shared.loginUser(userData: userData, onSuccess: { (loginUser) in
            self.currentUserData = userData
            guard let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
                return
            }
            print("token is: \(loginUser.token)")
            viewController.configure(loginUser: loginUser)
            self.navigationController?.setViewControllers([viewController], animated: true)
            
        }) { (error) in
            self.alertUser(title: "Invalid login", message: "Invalid username or password")
            print(error.localizedDescription)
        }
    }
    
}

extension LoginViewController {
    
    @IBAction func loginAction(_ sender: UIButton) {
        let params = getLoginInputData()
        if params.count == 0 {
            alertUser(title: "Wrong entry", message: "Please check all the fields")
            return
        }
        let userData = UserData(email: params["email"]!, password: params["password"]!)
        loginUser(userData: userData)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        let params = getLoginInputData()
        if params.count == 0 {
            alertUser(title: "Wrong entry", message: "Please check all the fields")
            return
        }
        let userData = UserData(email: params["email"]!, password: params["password"]!)
        
        ShowsApiClient.shared.registerUser(userData: userData, onSuccess: { (user) in
            self.user = user
            self.loginUser(userData: userData)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
}
