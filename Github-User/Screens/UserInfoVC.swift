//
//  UserInfoVC.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-17.
//

import UIKit
import SafariServices

protocol UserInfoVCDelegate: AnyObject {
    func didTapGithubProfiles(user: User)
    func didTapGetFollowers(user: User)
}

class UserInfoVC: UIViewController {
    weak var delegate: FollowersListVCDelegate!
    
    var username: String!
    let header = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    var itemView: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureViewController()
        getUserInfo()
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUser(for: username, completed: { [weak self] result in
            guard let self = self else { return }
            if case .success(let user) = result {
                DispatchQueue.main.async { self.configureUIElementsWithUserInfo(user: user) }
            }
            if case .failure(let error) = result {
                self.presentGFAlertOnMainThred(title: "Something went wrong", message: error.localizedDescription , buttonTitle: "OK")
            }
            
        })
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dusmissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func dusmissVC() {
        dismiss(animated: true)
    }
    
    func layoutUI () {
        let padding: CGFloat = 20
        
        itemView = [header, itemViewOne, itemViewTwo, dateLabel]
        
        for item in itemView {
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: header.bottomAnchor, constant: padding),
            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func addChildVC (childVC: UIViewController, to container: UIView) {
        addChild(childVC)
        container.addSubview(childVC.view)
        childVC.view.frame = container.bounds
        childVC.didMove(toParent: self)
        
        // @TODO: get deeper into topic
    }
    
    func configureUIElementsWithUserInfo(user: User) {
        let repoItemCV = GFRepoItemVC(user: user)
        repoItemCV.delegate = self
        let followerItemCV = GFFollowerItemVC(user: user)
        followerItemCV.delegate = self
        
        self.addChildVC(childVC: GFUserInfoHeaderVC(user: user), to: self.header)
        self.addChildVC(childVC: repoItemCV, to: self.itemViewOne)
        self.addChildVC(childVC: followerItemCV, to: self.itemViewTwo)
        self.dateLabel.text = "Github since \(user.createdAt.convertToDisplayString())"
    }
}

extension UserInfoVC: UserInfoVCDelegate {
    func didTapGithubProfiles(user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThred(title: "Error", message: "No Github profile found", buttonTitle: "OK")
            return
        }
        
        let safaryVC = SFSafariViewController(url: url)
        safaryVC.preferredBarTintColor = .systemGreen
        present(safaryVC, animated: true)
    }
    
    func didTapGetFollowers(user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThred(title: "No Followers", message: "This user has no followers, what a shame", buttonTitle: "Ok")
            return
        }
        delegate.didSelectFollower(user.login)
        dismiss(animated: true)
    }
}
