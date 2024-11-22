//
//  FavoriteCell.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-21.
//

import UIKit

class FavoriteCell: UITableViewCell {
    static let identifier: String = "GFFollowerFavoriteCell"
    
    let avatar = GFAvatartImageView(frame: .zero)
    let nameLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(favorite: Follower) {
        avatar.downloadImage(from: favorite.avatarUrl)
        nameLabel.text = favorite.login
    }
    
    private func configure() {
        let padding: CGFloat = 12
        addSubview(avatar)
        addSubview(nameLabel)
        
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatar.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatar.heightAnchor.constraint(equalToConstant: 60),
            avatar.widthAnchor.constraint(equalToConstant: 60),
            
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
        
    }
}
