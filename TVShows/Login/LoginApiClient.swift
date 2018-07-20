//
//  LoginApiClient.swift
//  TVShows
//
//  Created by Ivan Almer on 17/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
import CodableAlamofire

class LoginApiClient {
    
    static var shared = LoginApiClient()
    
    func loginUser(userData: UserData, onSuccess success: @escaping (LoginUser) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let params = ["email": userData.email, "password": userData.password]
        SVProgressHUD.show()
        Alamofire.request("https://api.infinum.academy/api/users/sessions",
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
            { (dataResponse: DataResponse<LoginUser>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let loginData):
                    success(loginData)
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
    func registerUser(userData: UserData, onSuccess success: @escaping (User) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let params = ["email": userData.email, "password": userData.password]
        SVProgressHUD.show()
        Alamofire.request("https://api.infinum.academy/api/users",
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
            { (dataResponse: DataResponse<User>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let user):
                    success(user)
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
}
