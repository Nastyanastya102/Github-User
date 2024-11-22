//
//  FavoritesVC.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-05.
//

import UIKit

class FavoritesVC: UIViewController {
    let tableView = UITableView()
    var favoriteUsers: [Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviagationBar()
        configuretableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    func configureNaviagationBar () {
        title = "Favorites"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configuretableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
    }
    
    func getFavorites () {
        PersistanceManager.retrivewFavoriteUsers {[weak self] result in
            guard let self else { return }
            switch result {
            case .success(let users):
                if users.isEmpty {
                    showEmptyView(with: "No favorites yet 😭", in: self.view)
                    return
                }
                self.favoriteUsers = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.view)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as! FavoriteCell
        cell.set(favorite: favoriteUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = favoriteUsers[indexPath.row]
        let destinationVC = FollowersListVC()
        destinationVC.title = user.login
        destinationVC.userName = user.login
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favoriteUser = favoriteUsers[indexPath.row]
        favoriteUsers.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        PersistanceManager.updateFavorire(favorite: favoriteUser, action: .remove) { [weak self] error in
            guard let self else { return }
            guard let error else {
                self.presentGFAlertOnMainThred(title: "Error", message: error?.localizedDescription ?? "Something went wrong", buttonTitle: "OK")
                return
            }
            self.presentGFAlertOnMainThred(title: "Success ✨", message: "Favorite user removed", buttonTitle: "OK")
        }
    }
}
