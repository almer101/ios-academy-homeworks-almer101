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
import Kingfisher

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
    
    func getShows(loginUser: LoginUser, onSuccess success: @escaping ([Show]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        SVProgressHUD.show()
        let headers = ["Authorization" : loginUser.token]
        Alamofire.request("\(baseURL)/api/shows",
                            method: .get,
                            parameters: nil,
                            encoding: JSONEncoding.default,
                            headers: headers)
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
    
    func getShowDetails(loginUser: LoginUser, showId: String, completion: @escaping (DataResponse<ShowDetails>) -> Void) {
        let headers = ["Authorization" : loginUser.token]
        Alamofire.request("\(baseURL)/api/shows/\(showId)",
                            method: .get,
                            parameters: nil,
                            encoding: JSONEncoding.default,
                            headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
                { (dataResponse: DataResponse<ShowDetails>) in
                    completion(dataResponse)
            }
    }
    
    func getEpisodes(loginUser: LoginUser, showId: String, completion: @escaping (DataResponse<[ShowEpisode]>) -> Void) {
        let headers = ["Authorization" : loginUser.token]
        Alamofire.request("\(baseURL)/api/shows/\(showId)/episodes",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
            { (dataResponse: DataResponse<[ShowEpisode]>) in
                completion(dataResponse)
        }
    }
    
    func getEpisodeDetails(loginUser: LoginUser, episodeId: String, completion: @escaping (DataResponse<Episode>) -> Void) {
        let headers = ["Authorization" : loginUser.token]
        Alamofire.request("\(baseURL)/api/episodes/\(episodeId)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
            { (dataResponse: DataResponse<Episode>) in
                completion(dataResponse)
        }
    }
    
    func addEpisode(loginUser: LoginUser, toShowWithId showId: String, episode: Episode, completion: @escaping (DataResponse<Episode>) -> Void) {
        let params = ["showId" : showId, "mediaId" : episode.mediaId ?? "", "title" : episode.title, "description" : episode.description, "episodeNumber" : episode.episodeNumber, "season" : episode.season]
        let headers = ["Authorization": loginUser.token]
        
        Alamofire
            .request("\(baseURL)/api/episodes",
                     method: .post,
                     parameters: params,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data") { (dataResponse: DataResponse<Episode>) in
                completion(dataResponse)
        }
    }
    
    func setPosterImage(forShow show: Show, onImageViewInCell cell: ShowListCollectionViewCell) {
        if show.id == cell.showId {
            setPosterImage(forImageUrl: show.imageUrl, onImageView: cell.showImageView)
        }
    }
    
    func setPosterImage(forShow show: Show, onImageViewInCell cell: ShowGridCollectionViewCell) {
        if show.id == cell.showId {
            setPosterImage(forImageUrl: show.imageUrl, onImageView: cell.showImageView)
        }
    }
    
    func setPosterImage(forImageUrl url: String, onImageView imageView: ImageView) {
        let url = URL(string: "http://api.infinum.academy" + url)
        imageView.kf.setImage(with: url)
        
    }
    
    func uploadImageOnAPI(token: String, image: UIImage, showId: String, completion: @escaping (SessionManager.MultipartFormDataEncodingResult) -> Void) {
        let headers = ["Authorization" : token]
        guard let imageByteData = UIImagePNGRepresentation(image) else { return }

        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageByteData,
                                     withName: "file",
                                     fileName: "image.jpg",
                                     mimeType: "image/png")
        }, to: "\(baseURL)/api/media", method: .post, headers: headers) { (result) in
            completion(result)
        }

    }
    
    func getComments(loginUser: LoginUser, forEpisode episode: Episode, completion: @escaping (DataResponse<[Comment]>) -> Void) {
        let headers = ["Authorization" : loginUser.token]
        Alamofire.request("\(baseURL)/api/episodes/\(episode.id)/comments",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
            { (dataResponse: DataResponse<[Comment]>) in
                completion(dataResponse)
        }
    }
    
    func postComment(loginUser: LoginUser, comment: Comment, completion: @escaping (DataResponse<Comment>) -> Void) {
        let params = ["text" : comment.text, "episodeId" : comment.episodeId]
        let headers = ["Authorization" : loginUser.token]
        
        Alamofire.request("\(baseURL)/api/comments",
                        method: .post,
                        parameters: params,
                        encoding: JSONEncoding.default,
                        headers: headers)
                .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
            { (dataResponse: DataResponse<Comment>) in
                completion(dataResponse)
        }
        
    }
    
}








