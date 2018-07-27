//
//  ShowTableViewCell.swift
//  TVShows
//
//  Created by Ivan Almer on 17/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    
    private var show: Show? = nil
    var showId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(show: Show) {
        self.show = show
        self.showId = show.id
        titleLabel.text = show.title
    }
    
    func setPlaceholderImage() {
        showImageView.image = UIImage(named: "poseter-placeholder")
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        setPlaceholderImage()
    }

}
