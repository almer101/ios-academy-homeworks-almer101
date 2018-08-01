//
//  ShowGridCollectionViewCell.swift
//  TVShows
//
//  Created by Ivan Almer on 27/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit

class ShowGridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var showImageView: UIImageView!
    
    private var show: Show? = nil
    var showId: String? = nil
    private let cornerRadius: CGFloat = 3
    
    func configure(show: Show) {
        self.show = show
        self.showId = show.id
        
        showImageView.layer.cornerRadius = cornerRadius
        showImageView.layer.masksToBounds = true
        self.clipsToBounds = false
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        setPlaceholderImage()
    }
    
    func setPlaceholderImage() {
        showImageView.image = UIImage(named: "poster-placeholder")
        
    }
    
}
