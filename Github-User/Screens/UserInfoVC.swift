//
//  UserInfoVC.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-17.
//

import UIKit

class UserInfoVC: UIViewController {
    var username: String!

    let header = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    
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
               
                DispatchQueue.main.async {
                    
                    self.addChildVC(childVC: GFUserInfoHeaderVC(user: user), to: self.header)
                    self.addChildVC(childVC: GFRepoItemVC(user: user), to: self.itemViewOne)
                    self.addChildVC(childVC: GFFollowerItemVC(user: user), to: self.itemViewTwo)
                }
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
        
        itemView = [header, itemViewOne, itemViewTwo]
        
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
        ])
    }
    
    func addChildVC (childVC: UIViewController, to container: UIView) {
        addChild(childVC)
        container.addSubview(childVC.view)
        childVC.view.frame = container.bounds
        childVC.didMove(toParent: self)
        
        // @TODO: get deeper into topic
    }
}
