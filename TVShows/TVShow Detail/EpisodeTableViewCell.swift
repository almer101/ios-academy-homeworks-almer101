//
//  EpisodeTableViewCell.swift
//  TVShows
//
//  Created by Ivan Almer on 22/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    @IBOutlet weak var episodeSeasonLabel: UILabel!
    @IBOutlet weak var episodeNameLabel: UILabel!
    
    private var episode: Episode? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(episode: Episode) {
        self.episode = episode
        
        episodeSeasonLabel.text = "S\(episode.season) Ep\(episode.episodeNumber)"
        episodeSeasonLabel.textColor = UIColor.tvShowsPink
        episodeNameLabel.text = episode.title
    }

}
