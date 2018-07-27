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
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var showId: String? = nil
    private var loginUser: LoginUser? = nil
    var delegate: AddNewEpisodeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addObservers()
    }
    
    func setup(showId: String, loginuser: LoginUser) {
        self.showId = showId
        self.loginUser = loginuser
        
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardDidShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardWillHide(notification: notification)
        }
    }
    
    func keyboardDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }

    func setupUI() {
        navigationItem.title = "Add episode"
        uploadPhotoLabel.textColor = UIColor.tvShowsPink
        episodeTitleTextField.delegate = self
        seasonNumberTextField.delegate = self
        episodeNumberTextField.delegate = self
        episodeDescriptionTextField.delegate = self
        
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
        guard let user = loginUser else { return }
        
        ShowsApiClient.shared.addEpisode(loginUser: user, toShowWithId: id, episode: ep) { [weak self] (dataResponse) in
            
            switch dataResponse.result {
            case .success(let episode):
                if let delegate = self?.delegate {
                    delegate.didAddNewEpisode(episode: episode)
                }
                self?.dismiss(animated: true, completion: nil)
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
        let episode = Episode(showId: id, mediaId: "", title: title, description: description, episodeNumber: episodeNumber, season: season, type: "episodes", imageUrl: "", id: "")
        return episode
    }
    
    func alertUser(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertViewController.addAction(closeAction)
        present(alertViewController, animated: true)
    }
    
}

extension AddNewEpisodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
