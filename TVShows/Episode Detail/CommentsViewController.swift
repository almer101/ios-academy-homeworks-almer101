//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Ivan Almer on 01/08/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit
import SVProgressHUD

class CommentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postCommentView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var postCommentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var noCommentsView: UIView!
    
    var episode: Episode?
    var loginUser: LoginUser?
    private var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        commentTextField.delegate = self
        
        setupUI()
        loadComments()
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        postButton.tintColor = .tvShowsPink
    }
    
    private func loadComments() {
        SVProgressHUD.show()
        guard let loginUser = loginUser, let episode = episode else { return }
        ShowsApiClient.shared.getComments(loginUser: loginUser, forEpisode: episode) { [weak self] (dataReponse) in
            
            SVProgressHUD.dismiss()
            switch dataReponse.result {
            case .success(let comments):
                self?.comments = comments
                self?.noCommentsView.isHidden = !comments.isEmpty
                self?.tableView.isHidden = comments.isEmpty
                self?.tableView.reloadData()
            case .failure(let error):
                print("Failure: \(error.localizedDescription)")
            }
        }
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
        postCommentViewBottomConstraint.constant = frame.size.height
    }
    
    func keyboardWillHide(notification: Notification) {
        postCommentViewBottomConstraint.constant = 0
    }
    
    @IBAction func postComment(_ sender: UIButton) {
        commentTextField.resignFirstResponder()
        
        guard let text = commentTextField.text,
            !text.isEmpty,
            let episode = episode,
            let loginUser = loginUser else {
                return
        }
        let comment = Comment(text: text, episodeId: episode.id, userEmail: "", id: "")
        SVProgressHUD.show()
        commentTextField.text = nil
        
        ShowsApiClient.shared.postComment(loginUser: loginUser, comment: comment) { [weak self] (dataResponse) in
            
            SVProgressHUD.dismiss()
            switch dataResponse.result {
            case .success(let comment):
                print("Success: \(comment)")
                self?.loadComments()
            case .failure(let error):
                print("Failure: \(error)")
            }
        }
    }
}

extension CommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as? CommentTableViewCell else { return UITableViewCell() }
        let comment = comments[indexPath.row]
        cell.setup(comment: comment)
        
        return cell
    }
}

extension CommentsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
