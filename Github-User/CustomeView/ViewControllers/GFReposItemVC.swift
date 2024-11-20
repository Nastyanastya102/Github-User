//
//  GFReposItemVC.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-18.
//


import UIKit

class GFRepoItemVC: GFItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        infoView.set(itemInfoType: .repos, with: user.publicRepos)
        infoView2.set(itemInfoType: .gists, with: user.publicGists)
        actionButton.set(.systemPurple, title: "Github Projects")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGithubProfiles(user: user)
    }
}
