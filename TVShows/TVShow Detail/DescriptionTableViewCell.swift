//
//  DescriptionTableViewCell.swift
//  TVShows
//
//  Created by Ivan Almer on 23/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var episodesCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(details: ShowDetails, episodesCount: Int) {
        showNameLabel.text = details.title
        descriptionLabel.text = details.description
        episodesCountLabel.text = "\(episodesCount)"
    }
}
