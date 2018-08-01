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
    @IBOutlet weak var infoLabel: UILabel!
    
    private var user: User? = nil
    private var currentUserData: UserData? = nil
    private var activeField: UITextField? = nil
    private var rememberMe = false
    private let invalidDataMessage = "Invalid email or password, please check all the fields"
    private let wrongEntryMessage = "Wrong format of email or password, please check all the fields"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkForRememberedUser()
        addObservers()
        addDelegateToTextFields()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func checkForRememberedUser() {
        if let email = UserDefaults.standard.value(forKey: Defaults.rememberMeEmail.rawValue) as? String,
            let password = UserDefaults.standard.value(forKey: Defaults.rememberMePassword.rawValue) as? String {
            rememberMe = true
            usernameTextField.text = email
            passwordTextField.text = password
            loginUser(userData: UserData(email: email, password: password))
        }
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil) { [weak self] (notification) in
                                                    self?.keyboardDidShow(notification: notification)
                                                }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { [weak self] (notification) in
                                                    self?.keyboardWillHide(notification: notification)
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
        infoLabel.isHidden = false
        infoLabel.alpha = 0
    }

    func keyboardDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
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
        ShowsApiClient.shared.loginUser(userData: userData, onSuccess: { [weak self] (loginUser) in
            self?.currentUserData = userData
            guard let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
                return
            }
            guard let remember = self?.rememberMe else { return }
            if remember {
                UserDefaults.standard.set(userData.email, forKey: Defaults.rememberMeEmail.rawValue)
                UserDefaults.standard.set(userData.password, forKey: Defaults.rememberMePassword.rawValue)
            }
            viewController.configure(loginUser: loginUser)
            print("The token is: \(loginUser.token)")
            self?.navigationController?.setViewControllers([viewController], animated: true)
            
        }) { [weak self] (error) in
            self?.infoLabel.text = self?.invalidDataMessage
            self?.infoLabel.show(withDuration: 3)
            self?.shakeButtonAndFields()
            print(error.localizedDescription)
        }
    }
    
    func shakeButtonAndFields() {
        loginButton.shake()
        usernameTextField.shake()
        passwordTextField.shake()
        
    }
    
}

extension LoginViewController {
    
    @IBAction func loginAction(_ sender: UIButton) {
        let params = getLoginInputData()
        if params.count == 0 {
            infoLabel.text = invalidDataMessage
            infoLabel.show(withDuration: 3)
            shakeButtonAndFields()
            return
        }
        let userData = UserData(email: params["email"]!, password: params["password"]!)
        loginUser(userData: userData)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        let params = getLoginInputData()
        if params.count == 0 {
            infoLabel.text = wrongEntryMessage
            infoLabel.show(withDuration: 3)
            shakeButtonAndFields()
            return
        }
        let userData = UserData(email: params["email"]!, password: params["password"]!)
        
        ShowsApiClient.shared.registerUser(userData: userData, onSuccess: { [weak self] (user) in
            self?.user = user
            self?.loginUser(userData: userData)
            
        }) { [weak self] (error) in
            self?.infoLabel.text = self?.wrongEntryMessage
            self?.infoLabel.show(withDuration: 3)
            self?.shakeButtonAndFields()
            print(error.localizedDescription)
        }
    }
    
    @IBAction func rememberMeToggled(_ sender: UIButton) {
        rememberMe = !rememberMe
        sender.setImage(
            UIImage(named: rememberMe ? "ic-checkbox-filled" : "ic-checkbox-empty"), for: .normal)
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
        textField.resignFirstResponder()
        return true
    }
    
}
