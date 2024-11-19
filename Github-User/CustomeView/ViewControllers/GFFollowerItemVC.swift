//
//  GFFollowerItemVC.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-18.
//


import UIKit

class GFFollowerItemVC: GFItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        infoView.set(itemInfoType: .followers, with: user.followers)
        infoView2.set(itemInfoType: .following, with: user.following)
        actionButton.set(.systemGreen, title: "Followers")
    }
}
