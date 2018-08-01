//
//  Media.swift
//  TVShows
//
//  Created by Ivan Almer on 29/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import Foundation

struct Media: Codable {
    
    let path: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {        
        case path
        case type
        case id = "_id"
    }
    
}
