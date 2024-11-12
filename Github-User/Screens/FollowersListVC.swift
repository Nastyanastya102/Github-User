
import UIKit

class FollowersListVC: UIViewController {
    enum Section {
        case main
    }
    
    var userName: String = ""
    var followers: [Follower] = []
    let tableView = UITableView()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        getFollowers()
        configureCollectionView()
        configureDataSource()
//        setupTableView()

    }
    
    func getFollowers() {
        NetworkManager.shared.followers(for: userName, page: 1) { [self] result in
            switch(result) {
            case .success(let flw):
                self.followers = flw
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
}

extension FollowersListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GFFollowerCellTableViewCell", for: indexPath) as? GFFollowerCellTableViewCell else {
                   return UITableViewCell()
               }
        cell.configure(with:followers[indexPath.row].avatarUrl, text: followers[indexPath.row].login)
        cell.selectionStyle = .none
        return cell
    }
    
    func createThereCollectionFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let avaiableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = avaiableWidth / 3
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return layout
    }
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          print("Selected item: \(followers[indexPath.row])")
      }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GFFollowerCellTableViewCell.self, forCellReuseIdentifier: "GFFollowerCellTableViewCell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThereCollectionFlowLayout())
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
