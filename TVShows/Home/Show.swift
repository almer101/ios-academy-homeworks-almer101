//
//  Show.swift
//  TVShows
//
//  Created by Ivan Almer on 17/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import Foundation

struct Show: Codable {
    
    let id: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
    }
    
}
