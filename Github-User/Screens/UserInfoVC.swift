//
//  UserInfoVC.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-17.
//

import UIKit

class UserInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dusmissVC))
        navigationItem.rightBarButtonItem = doneButton

    }
    
    @objc func dusmissVC() {
        dismiss(animated: true)
    }
}
