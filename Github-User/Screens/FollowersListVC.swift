//
//  FollowersListVC.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-08.
//

import UIKit

class FollowersListVC: UIViewController {
    var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
    }
}
