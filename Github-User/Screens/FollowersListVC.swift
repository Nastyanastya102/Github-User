
import UIKit

class FollowersListVC: UIViewController {
    enum Section {
        case main
    }
    var page: Int = 1
    var hasMore: Bool = true
    var userName: String = ""
    var followers: [Follower] = []
    let tableView = UITableView()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        getFollowers(for: userName, page: page)
        configureCollectionView()
        configureDataSource()
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
                self.updateData()

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
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView) { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GFFollowerCell.identifier, for: indexPath) as! GFFollowerCell
            cell.set(follower: follower)
            return cell
        }
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
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
