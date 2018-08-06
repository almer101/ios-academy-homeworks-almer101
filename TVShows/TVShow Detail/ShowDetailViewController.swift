//
//  ShowDetailViewController.swift
//  TVShows
//
//  Created by Ivan Almer on 22/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit
import SVProgressHUD

class ShowDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var show: Show? = nil
    private var loginUser: LoginUser? = nil
    private var showDetails: ShowDetails? = nil
    private var episodes: [Episode] = []
    private var episodesToLoad: Int = 0
    private var imageHeightCoefficient: CGFloat = 0.38
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        navigationController?.setNavigationBarHidden(true, animated: true)
        SVProgressHUD.show()
        getShowDetails()
    }
    
    func setup(show: Show, loginUser: LoginUser) {
        self.show = show
        self.loginUser = loginUser
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
    }
    
    @objc func refreshContent() {
        tableView.refreshControl?.beginRefreshing()
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    @IBAction func returnToThePreviousScreen(_ sender: UIButton) {
        SVProgressHUD.dismiss()
        navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func addNewEpisode(_ sender: UIButton) {
        guard let viewController = UIStoryboard(name: "ShowDetail", bundle: nil).instantiateViewController(withIdentifier: "AddNewEpisodeViewController") as? AddNewEpisodeViewController else { return }
        guard let show = show else { return }
        guard let user = loginUser else { return }
        viewController.setup(showId: show.id, loginuser: user)
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion:  nil)
    }
}

extension ShowDetailViewController {
    
    func getShowDetails() {
        guard let show = show else { return }
        guard let user = loginUser else { return }
        ShowsApiClient.shared.getShowDetails(loginUser: user, showId: show.id) { [weak self] (dataResponse) in
            
            switch dataResponse.result {
            case .success(let details):
                self?.showDetails = details
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                self?.getEpisodes()
            case .failure(let error):
                print("An error occurred in getting the details: \(error.localizedDescription)")
            }
        }
    }
    
    func getEpisodes() {
        guard let show = show else { return }
        guard let user = loginUser else { return }
        ShowsApiClient.shared.getEpisodes(loginUser: user, showId: show.id) { [weak self] (dataResponse) in
            
            switch dataResponse.result {
            case .success(let episodes):
                self?.episodesToLoad = episodes.count
                if self?.episodesToLoad == 0 { SVProgressHUD.dismiss() }
                self?.getEpisodesDetails(episodes: episodes)
            case .failure(let error):
                print("An error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    func getEpisodesDetails(episodes: [ShowEpisode]) {
        for ep in episodes {
            getEpisodeDetails(episode: ep)
        }
    }
    
    func getEpisodeDetails(episode: ShowEpisode) {
        guard let user = loginUser else { return }
        ShowsApiClient.shared.getEpisodeDetails(loginUser: user, episodeId: episode.id) { [weak self] (dataResponse) in
            
            switch dataResponse.result {
            case .success(let episode):
                self?.episodes.append(episode)
                self?.episodesToLoad -= 1
                if self?.episodesToLoad == 0 {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            case .failure(let error):
                print("An error occurred: \(error.localizedDescription)")
            }
        }
    }
}

extension ShowDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewTableViewCell") as? ImageViewTableViewCell else {
                return UITableViewCell()
            }
            if let image = UIImage(named: "placeholder") {
                cell.setup(image: image)
            }
            if let show = show {
                ShowsApiClient.shared.setPosterImage(forImageUrl: show.imageUrl, onImageView: cell.showImageView)
            }
            return cell
            
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell") as? DescriptionTableViewCell else {
                return UITableViewCell()
            }
            if let details = showDetails {
                cell.setup(details: details, episodesCount: episodes.count)
            }
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell") as? EpisodeTableViewCell else {
                return UITableViewCell()
            }
            cell.setup(episode: episodes[indexPath.row - 2])
            return cell
        }
    }
    
}

extension ShowDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.frame.size.height * imageHeightCoefficient
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 1 { return }
        guard let viewController = UIStoryboard(name: "EpisodeDetail", bundle: nil).instantiateViewController(withIdentifier: "EpisodeDetailViewController") as? EpisodeDetailViewController else { return }
       
        let episode = episodes[indexPath.row - 2]
        viewController.episode = episode
        viewController.loginUser = loginUser
        
        navigationController?.pushViewController(viewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension ShowDetailViewController: AddNewEpisodeViewControllerDelegate {
    
    func didAddNewEpisode(episode: Episode) {
        SVProgressHUD.show()
        episodes.append(episode)
        tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
}




