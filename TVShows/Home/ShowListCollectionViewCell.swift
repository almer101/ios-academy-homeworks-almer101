//
//  ShowListCollectionViewCell.swift
//  TVShows
//
//  Created by Ivan Almer on 27/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit

class ShowListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var showTitleLabel: UILabel!
    
    private var show: Show? = nil
    var showId: String? = nil
    private let cornerRadius: CGFloat = 3
    
    func configure(show: Show) {
        self.show = show
        self.showId = show.id
        
        showTitleLabel.text = show.title
        
        showImageView.layer.cornerRadius = cornerRadius
        showImageView.layer.masksToBounds = true
        containerView.layer.cornerRadius = cornerRadius
        containerView.clipsToBounds = false
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        setPlaceholderImage()
    }
    
    func setPlaceholderImage() {
        showImageView.image = UIImage(named: "poster-placeholder")
        
    }
}
