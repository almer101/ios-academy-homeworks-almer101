//
//  EpisodeDetailViewController.swift
//  TVShows
//
//  Created by Ivan Almer on 31/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: UIViewController {

    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var episodeDescriptionLabel: UILabel!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var initialImageHeight: CGFloat = 0.0
    private var initialContentOffset: CGFloat = 0.0
    var episode: Episode?
    var loginUser: LoginUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        initialImageHeight = episodeImageView.frame.size.height
        initialContentOffset = scrollView.contentOffset.y
        scrollView.delegate = self
    }
    
    private func setupUI() {
        commentsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentsTapped)))
        episodeNumberLabel.textColor = UIColor.tvShowsPink
        episodeDescriptionLabel.textColor = UIColor.tvShowsBlack
        
        guard let episode = episode else { return }
        
        episodeTitleLabel.text = episode.title
        episodeNumberLabel.text = "S\(episode.season) Ep\(episode.episodeNumber)"
        episodeDescriptionLabel.text = episode.description
        
        if let url = episode.imageUrl {
            ShowsApiClient.shared.setPosterImage(forImageUrl: url, onImageView: episodeImageView)
        }
    }
    
    @objc private func commentsTapped() {
        guard let viewController = UIStoryboard(name: "EpisodeDetail", bundle: nil).instantiateViewController(withIdentifier: "CommentsViewController") as? CommentsViewController else { return }
        viewController.episode = episode
        viewController.loginUser = loginUser
        
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension EpisodeDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if(yPosition < 0) {
            episodeImageView.frame.origin.y = (yPosition - initialContentOffset)
            episodeImageView.frame.size.height = initialImageHeight - yPosition
        } else {
            episodeImageView.frame.origin.y = yPosition / 3
        }

    }
}
