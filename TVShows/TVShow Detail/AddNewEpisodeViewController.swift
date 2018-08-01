//
//  AddNewEpisodeViewController.swift
//  TVShows
//
//  Created by Ivan Almer on 23/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

protocol AddNewEpisodeViewControllerDelegate {
    
    func didAddNewEpisode(episode: Episode)
}

class AddNewEpisodeViewController: UIViewController {

    @IBOutlet weak var uploadPhotoLabel: UILabel!
    @IBOutlet weak var episodeTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var episodeNumberTextField: UITextField!
    @IBOutlet weak var episodeDescriptionTextField: UITextField!
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var showId: String? = nil
    private var loginUser: LoginUser? = nil
    var delegate: AddNewEpisodeViewControllerDelegate?
    private var media: Media? = nil
    
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
        
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteSelectedImage)))
        
        infoLabel.alpha = 0
    }
    
    @objc func deleteSelectedImage() {
        print("Tu sam")
        let actionSheet = UIAlertController(title: "Delete selected photo?", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (action: UIAlertAction) in
            self?.uploadImageView.image = nil
            self?.media = nil
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    @objc func didCancelAddingNewEpisode() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAddEpisode() {
        guard let ep = extractModelFromFields() else {
            shakeTextFields()
            infoLabel.show(withDuration: 3)
            return
        }
        guard let id = showId else { return }
        guard let user = loginUser else { return }
        
        print(ep)
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
        let episode = Episode(showId: id, mediaId: media?.id ?? "", title: title, description: description, episodeNumber: episodeNumber, season: season, type: "episodes", imageUrl: media?.path ?? "", id: "")
        return episode
    }
    
    func alertUser(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertViewController.addAction(closeAction)
        present(alertViewController, animated: true)
    }
    
    func shakeTextFields() {
        episodeTitleTextField.shake()
        seasonNumberTextField.shake()
        episodeNumberTextField.shake()
        episodeDescriptionTextField.shake()
    }
    
    @IBAction func uploadPhotoTapped(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Choose image Source", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { [weak self] (action: UIAlertAction) in
            pickerController.sourceType = .photoLibrary
            self?.present(pickerController, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                pickerController.sourceType = .camera
                self?.present(pickerController, animated: true)
            } else {
                print("Camera not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)

    }
    
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "Choose image Source", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (action: UIAlertAction) in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
}

extension AddNewEpisodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension AddNewEpisodeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadImageView.image = pickedImage
            SVProgressHUD.show()
            guard let user = loginUser, let showId = showId else { return }
            ShowsApiClient.shared.uploadImageOnAPI(token: user.token, image: pickedImage, showId: showId) { [weak self] (result) in
                switch result {
                case .success(let uploadRequest, _, _):
                    self?.processUploadRequest(uploadRequest)
                case .failure(let error):
                    print("FAILURE: \(error.localizedDescription)")
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest.responseDecodableObject(keyPath: "data") { [weak self] (response: DataResponse<Media>) in
            switch response.result {
            case .success(let media):
                print("Success: \(media)")
                self?.media = media
                SVProgressHUD.dismiss()
            case .failure(let error):
                print("Failure: \(error.localizedDescription)")
            }
        }
    }
}

extension AddNewEpisodeViewController: UINavigationControllerDelegate {
    
}
