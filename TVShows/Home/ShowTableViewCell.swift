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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(show: Show) {
        self.show = show
        titleLabel.text = show.title
    }
    
    func configure(image: UIImage) {
        showImageView.image = image
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        showImageView.image = UIImage(named: "poseter-placeholder")
    }

}
