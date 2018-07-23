//
//  ShowDetails.swift
//  TVShows
//
//  Created by Ivan Almer on 22/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import Foundation

struct ShowDetails: Codable {
    
    let type: String
    let title: String
    let description: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case id = "_id"
    }
    
}
