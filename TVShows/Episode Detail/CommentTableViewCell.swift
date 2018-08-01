//
//  CommentTableViewCell.swift
//  TVShows
//
//  Created by Ivan Almer on 01/08/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var moodImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(comment: Comment) {
        usernameLabel.text = comment.userEmail
        usernameLabel.textColor = .tvShowsPink
        
        commentTextLabel.text = comment.text
        selectionStyle = .none
        
        let random = arc4random_uniform(3) + 1
        moodImageView.image = UIImage(named: "img-placeholder-user\(random)")
    }

}
