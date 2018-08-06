//
//  Comment.swift
//  TVShows
//
//  Created by Ivan Almer on 01/08/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import Foundation

struct Comment: Codable {
    
    let text: String
    let episodeId: String
    let userEmail: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case episodeId
        case userEmail
        case id = "_id"
    }
    
}
