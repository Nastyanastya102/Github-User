//
//  CFUserInfoHeaderVC.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-17.
//

import UIKit

class GFUserInfoHeaderVC: UIViewController {

    
    let avatarView = GFAvatartImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34)
    let nameLabel = GFSecondaryLabel(size: 18)
    let locationLabel = GFSecondaryLabel(size: 18)
    let locationImageView = UIImageView(image: UIImage(systemName: "location"))
    let bioLabel = GFBodyLabel(textAlignment: .left)
    
    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layoutUI()
        configureUIElements()
    }
    
    func configureUIElements () {
        avatarView.downloadImage(from: user.avatarUrl)
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? "Unknown"
        locationLabel.text = user.location ?? "No location"
        bioLabel.text = user.bio ?? ""
        bioLabel.numberOfLines = 3
        
        locationImageView.image = UIImage(systemName: SFSymbols.location)
    }
    
    func addSubviews () {
        view.addSubview(avatarView)
        view.addSubview(usernameLabel)
        view.addSubview(nameLabel)
        view.addSubview(locationLabel)
        view.addSubview(locationImageView)
        view.addSubview(bioLabel)
    }
    
    func layoutUI () {
        let padding: CGFloat = 20
        let textImagePadding: CGFloat = 12
        let avatarSize: CGFloat = 90
        
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            avatarView.widthAnchor.constraint(equalToConstant: avatarSize),
            avatarView.heightAnchor.constraint(equalToConstant: avatarSize),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: textImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: textImagePadding),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bioLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: padding),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            bioLabel.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
