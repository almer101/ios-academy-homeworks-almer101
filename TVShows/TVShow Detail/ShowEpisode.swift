//
//  ShowEpisode.swift
//  TVShows
//
//  Created by Ivan Almer on 22/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import Foundation

struct ShowEpisode: Codable {
    
    let title: String
    let description: String
    let id: String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case id = "_id"
        case imageUrl
    }
    
}
