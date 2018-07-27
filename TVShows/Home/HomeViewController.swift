
//
//  HomeViewController.swift
//  TVShows
//
//  Created by Ivan Almer on 16/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var shows: [Show] = []
    private var loginUser: LoginUser? = nil
    private let listViewRowHeight: CGFloat = 120
    private let gridViewRowHeight: CGFloat = 180
    private let gridCellWidthCoeffiecient: CGFloat = 0.46
    private let heightToWidthRatio: CGFloat = 1.5
    private var layoutType = LayoutType.list {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic-listview"), style: .plain, target: self, action: #selector(changeView))
        if let type = UserDefaults.standard.value(forKey: Defaults.preferredLayoutType.rawValue) as? String,
            let layoutType = LayoutType(rawValue: type) {
            self.layoutType = layoutType
        }
    }
    
    @objc func logoutUser() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (alert: UIAlertAction!) in self?.performLogout()})
        alert.addAction(cancelAction)
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func changeView() {
        layoutType = layoutType == .grid ? .list : .grid
        UserDefaults.standard.set(layoutType.rawValue, forKey: Defaults.preferredLayoutType.rawValue)
    }
    
    func performLogout() {
        UserDefaults.standard.removeObject(forKey: Defaults.rememberMeEmail.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.rememberMePassword.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.preferredLayoutType.rawValue)
        guard let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    func setupTableView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func loadShows() {
        guard let user = loginUser else { return }
        ShowsApiClient.shared.getShows(loginUser: user, onSuccess: { [weak self] (shows) in
            self?.shows = shows
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let show = shows[indexPath.row]
        
        switch layoutType {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: layoutType.rawValue, for: indexPath) as? ShowListCollectionViewCell else { return UICollectionViewCell()}
            cell.configure(show: show)
            ShowsApiClient.shared.setPosterImage(forShow: show, onImageViewInCell: cell)
            return cell
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: layoutType.rawValue, for: indexPath) as? ShowGridCollectionViewCell else { return UICollectionViewCell()}
            cell.configure(show: show)
            ShowsApiClient.shared.setPosterImage(forShow: show, onImageViewInCell: cell)
            return cell
        }
    }

}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "ShowDetail", bundle: nil).instantiateViewController(withIdentifier: "ShowDetailViewController") as? ShowDetailViewController else {
            return
        }
        let show = shows[indexPath.row]
        guard let loginUser = loginUser else {
            return
        }
        viewController.setup(show: show, loginUser: loginUser)
        navigationController?.pushViewController(viewController, animated: true)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch layoutType {
        case .list:
            let width = view.frame.size.width
            return CGSize(width: width, height: listViewRowHeight)
        case .grid:
            let width = view.frame.size.width * gridCellWidthCoeffiecient
            return CGSize(width: width, height: width * heightToWidthRatio)
        }
    }
    
}












