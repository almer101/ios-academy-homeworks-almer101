//
//  AddNewEpisodeViewController.swift
//  TVShows
//
//  Created by Ivan Almer on 23/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit

protocol AddNewEpisodeViewControllerDelegate {
    
    func didAddNewEpisode(episode: Episode)
}

class AddNewEpisodeViewController: UIViewController {

    @IBOutlet weak var uploadPhotoLabel: UILabel!
    @IBOutlet weak var episodeTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var episodeNumberTextField: UITextField!
    @IBOutlet weak var episodeDescriptionTextField: UITextField!
    
    private var showId: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setup(showId: String) {
        self.showId = showId
        
    }

    func setupUI() {
        navigationItem.title = "Add episode"
        uploadPhotoLabel.textColor = UIColor.tvShowsPink
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAddingNewEpisode))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didSelectAddEpisode))
        navigationController?.navigationBar.tintColor = UIColor.tvShowsPink
    }
    
    @objc func didCancelAddingNewEpisode() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAddEpisode() {
        guard let ep = extractModelFromFields() else {
            alertUser(title: "Invalid input", message: "Please check all the fields")
            return
        }
        guard let id = showId else { return }
        ShowsApiClient.shared.addEpisode(toShowWithId: id, episode: ep) { [weak self] (dataResponse) in
            
            switch dataResponse.result {
            case .success(let episode):
                print("Adding succeeded")
            case .failure(let error):
                self?.alertUser(title: "Error", message: "An error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    func extractModelFromFields() -> Episode? {
        guard let title = episodeTitleTextField.text,
            !title.isEmpty else { return nil }
        guard let description = episodeDescriptionTextField.text,
            !description.isEmpty else { return nil }
        guard let season = seasonNumberTextField.text,
            !season.isEmpty,
            let _ = Int(season) else { return nil }
        guard let episodeNumber = episodeNumberTextField.text,
            !episodeNumber.isEmpty,
            let _ = Int(episodeNumber) else { return nil }
        guard let id = showId else { return nil }
        let episode = Episode(showId: id, title: title, description: description, episodeNumber: episodeNumber, season: season, type: "episode", id: "")
        return episode
    }
    
    func alertUser(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertViewController.addAction(closeAction)
        present(alertViewController, animated: true)
    }
    
}
