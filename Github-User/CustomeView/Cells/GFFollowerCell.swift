//
//  GFFollowerCell.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-10.
//

import UIKit

class GFFollowerCell: UICollectionViewCell {
    static let identifier: String = "GFFollowerCell"
    
    let avatar = GFAvatartImageView(frame: .zero)
    let nameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Follower) {
        avatar.downloadImage(from: follower.avatarUrl)
        nameLabel.text = follower.login
    }
    
    private func setupSubviews() {
        contentView.addSubview(avatar)
        contentView.addSubview(nameLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatar.heightAnchor.constraint(equalTo: avatar.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
