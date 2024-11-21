
import UIKit

protocol FollowersListVCDelegate: AnyObject {
    func didSelectFollower(_ username: String)
}

class FollowersListVC: UIViewController {
    enum Section {
        case main
    }
    var page: Int = 1
    var hasMore: Bool = true
    var userName: String = ""
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var isSearching = false

    let tableView = UITableView()
    var searchController: UISearchController!
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        configureViewController()
        configureCollectionView()
        getFollowers(for: userName, page: page)
        configureDataSource()
        configureSearchController()
    }
    
    func getFollowers(for userName: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.followers(for: userName, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingViewHandler()
            switch(result) {
            case .success(let flw):
                if followers.count > 50 {
                    self.hasMore = false
                }
                self.followers.append(contentsOf: flw)
                if self.followers.isEmpty {
                    let message = "No followers found for \(userName)"
                    DispatchQueue.main.async {
                        self.showEmptyView(with: message, in: self.view)
                        return
                    }
                   
                }
                self.updateData(followers: flw)

                break
            case .failure(let error):
                switch error {
                case .badRequest:
                    presentGFAlertOnMainThred(title: "Unable to get data", message: "Please check your internet connection", buttonTitle: "OK")
                    break
                case .unableToDecode:
                    presentGFAlertOnMainThred(title: "Unable to parse data", message: "Please check your internet connection", buttonTitle: "OK")
                    break
                case .overflow:
                    presentGFAlertOnMainThred(title: "Overflow", message: "Please contact support", buttonTitle: "OK")
                case .invalidUrl:
                    presentGFAlertOnMainThred(title: "Invalid url", message: "Please contact support or try different username", buttonTitle: "OK")
                case .dataError:
                    presentGFAlertOnMainThred(title: "Unable to parse data", message: "Please check your internet connection", buttonTitle: "OK")
                }
            }
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
     
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThereCollectionFlowLayout(in: view))
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.register(GFFollowerCell.self, forCellWithReuseIdentifier: GFFollowerCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView) { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GFFollowerCell.identifier, for: indexPath) as! GFFollowerCell
            cell.set(follower: follower)
            return cell
        }
    }
    
    func updateData(followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func configureSearchController() {
        searchController = UISearchController()

        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.isActive = true
    }
}

extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            guard hasMore else { return }
            page += 1
            getFollowers(for: userName, page: page)
        }
    }
}

extension FollowersListVC: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        isSearching = true
        filterFollowers(by: searchText)
    }
      
    func filterFollowers(by searchText: String) {
        filteredFollowers = followers.filter {$0.login.lowercased().contains(searchText.lowercased())}
        updateData(followers: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(followers: followers)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let follower = isSearching ? filteredFollowers[indexPath.row] : followers[indexPath.row]
        
        let destinationVC = UserInfoVC()
        destinationVC.username = follower.login
        destinationVC.delegate = self
        
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
}

extension FollowersListVC: FollowersListVCDelegate {
    func didSelectFollower(_ username: String) {
        self.userName = username
        title = username
        followers.removeAll()
        filteredFollowers.removeAll()
        page = 1
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(for: username, page: page)
    }
}


//OLD WAY
//extension FollowersListVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return followers.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GFFollowerCellTableViewCell", for: indexPath) as? GFFollowerCellTableViewCell else {
//            return UITableViewCell()
//        }
//        cell.configure(with:followers[indexPath.row].avatarUrl, text: followers[indexPath.row].login)
//        cell.selectionStyle = .none
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Selected item: \(followers[indexPath.row])")
//    }
//
//func setupTableView() {
//    view.addSubview(tableView)
//
//    tableView.delegate = self
//    tableView.dataSource = self
//    tableView.translatesAutoresizingMaskIntoConstraints = false
//    tableView.register(GFFollowerCellTableViewCell.self, forCellReuseIdentifier: "GFFollowerCellTableViewCell")
//
//    NSLayoutConstraint.activate([
//        tableView.topAnchor.constraint(equalTo: view.topAnchor),
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//    ])
//
//}
//}
