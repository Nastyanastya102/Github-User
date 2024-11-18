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

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dusmissVC))
        navigationItem.rightBarButtonItem = doneButton
        NetworkManager.shared.getUser(for: username, completed: { [weak self] result in
            guard let self = self else { return }
            print(result)
            if case .success(let user) = result {
                DispatchQueue.main.async {
                    self.addChildVC(childVC: GFUserInfoHeaderVC(user: user), to: self.header)
                }
            }
            
        })

    }
    
    @objc func dusmissVC() {
        dismiss(animated: true)
    }
    
    func layoutUI () {
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    func addChildVC (childVC: UIViewController, to container: UIView) {
        print("HERE")
        addChild(childVC)
        container.addSubview(childVC.view)
        childVC.view.frame = container.bounds
        childVC.didMove(toParent: self)
    }
}
