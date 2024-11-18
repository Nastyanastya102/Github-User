//
//  UserInfoVC.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-17.
//

import UIKit

class UserInfoVC: UIViewController {
    var username: String!
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dusmissVC))
        navigationItem.rightBarButtonItem = doneButton
        NetworkManager.shared.getUser(for: username, completed: { [weak self] result in
            if case .success(let user) = result {
                self?.user = user
            }
            
        })

    }
    
    @objc func dusmissVC() {
        dismiss(animated: true)
    }
}
