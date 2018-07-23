//
//  ImageViewTableViewCell.swift
//  TVShows
//
//  Created by Ivan Almer on 23/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit

class ImageViewTableViewCell: UITableViewCell {

    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    
    private let rowHeight: CGFloat = 170
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(image : UIImage) {
        showImageView.image = image
        frame.size.height = rowHeight
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white, UIColor.black]
        gradientLayer.frame = gradientLayer.frame
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
