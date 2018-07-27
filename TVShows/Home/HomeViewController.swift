
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
    private let rowHeight: CGFloat = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
        loadShows()
    }
    
    func configure(loginUser: LoginUser) {
        self.loginUser = loginUser
    }
    
    func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic-logout"), style: .plain, target: self, action: #selector(logoutUser))
    }
    
    @objc func logoutUser() {
        alertUser(title: "Logout", message: "Are you sure you want to logout?")
    }
    
    func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (alert: UIAlertAction!) in self?.performLogout()})
        alert.addAction(cancelAction)
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
    }
    
    func performLogout() {
        UserDefaults.standard.removeObject(forKey: Defaults.rememberMeEmail.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.rememberMePassword.rawValue)
        guard let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = rowHeight
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
        let show = shows[indexPath.row]
        cell.configure(show: show)
        cell.setPlaceholderImage()
        ShowsApiClient.shared.setPosterImage(forShow: show, onImageViewInCell: cell)
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
        viewController.setup(show: show, loginUser: loginUser)
        navigationController?.pushViewController(viewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
