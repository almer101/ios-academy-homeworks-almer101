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

class ShowsApiClient {
    
    static var shared = ShowsApiClient()
    private let baseURL = "https://api.infinum.academy"
    
    func loginUser(userData: UserData, onSuccess success: @escaping (LoginUser) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let params = ["email": userData.email, "password": userData.password]
        SVProgressHUD.show()
        Alamofire.request("\(baseURL)/api/users/sessions",
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
        Alamofire.request("\(baseURL)/api/users",
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
    
    func getShows(onSuccess success: @escaping ([Show]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        SVProgressHUD.show()
        Alamofire.request("\(baseURL)/api/shows",
                            method: .get,
                            parameters: nil,
                            encoding: JSONEncoding.default)
                .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
        { (dataResponse: DataResponse<[Show]>) in
            
            SVProgressHUD.dismiss()
            
            switch dataResponse.result {
            case .success(let shows):
                success(shows)
            case .failure(let error):
                failure(error)
            }   
        }
    }
    
}
