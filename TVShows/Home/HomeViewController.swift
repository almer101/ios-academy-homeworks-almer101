
//
//  HomeViewController.swift
//  TVShows
//
//  Created by Ivan Almer on 16/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var shows: [Show] = []
    
    private var loginUser: LoginUser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        loadShows()
    }
    
    func configure(loginUser: LoginUser) {
        self.loginUser = loginUser
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func loadShows() {
        guard let user = loginUser else { return }
        ShowsApiClient.shared.getShows(loginUser: user, onSuccess: { [weak self] (shows) in
            self?.shows = shows
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTableViewCell") as? ShowTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(show: shows[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action: UITableViewRowAction, indexPath: IndexPath) in
            self?.shows.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            tableView.endUpdates()
        }
        return [delete]
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "ShowDetail", bundle: nil).instantiateViewController(withIdentifier: "ShowDetailViewController") as? ShowDetailViewController else {
            return
        }
        let show = shows[indexPath.row]
        guard let loginUser = loginUser else {
            return
        }
        viewController.setup(showID: show.id, loginUser: loginUser)
        navigationController?.pushViewController(viewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
