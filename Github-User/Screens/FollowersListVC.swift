
import UIKit

class FollowersListVC: UIViewController {
    var userName: String = ""
    var followers: [Follower] = []
    let tableView = UITableView()
    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()

        NetworkManager.shared.followers(for: userName, page: 1) { [self] result in
            switch(result) {
            case .success(let flw):
                self.followers = flw
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = followers[indexPath.row].login
        return cell
    }
    
    // MARK: - UITableViewDelegate

      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          print("Selected item: \(items[indexPath.row])")
      }
    
    func setupTableView() {
           view.addSubview(tableView)

           tableView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               tableView.topAnchor.constraint(equalTo: view.topAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
           ])

           tableView.delegate = self
           tableView.dataSource = self

           tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       }
}
