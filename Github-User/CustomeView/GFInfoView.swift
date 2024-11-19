//
//  GFInfoView.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-18.
//

import UIKit

enum InfoType {
    case repos
    case followers
    case gists
    case following
}

class GFInfoView: UIView {
    let symbolimageView = UIImageView()
    let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(symbolimageView)
        addSubview(titleLabel)
        addSubview(countLabel)
        
        symbolimageView.translatesAutoresizingMaskIntoConstraints = false
        symbolimageView.contentMode = .scaleAspectFill
        symbolimageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolimageView.topAnchor.constraint(equalTo: topAnchor),
            symbolimageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolimageView.heightAnchor.constraint(equalToConstant: 20),
            symbolimageView.widthAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolimageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolimageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            

            countLabel.topAnchor.constraint(equalTo: symbolimageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func set(itemInfoType: InfoType, with count: Int) {
        countLabel.text = "\(count)"
        
        switch itemInfoType {
        case .followers:
            symbolimageView.image = UIImage(named: SFSymbols.location)
            titleLabel.text = "Followers"
            break
        case .repos:
            symbolimageView.image = UIImage(named: SFSymbols.repos)
            titleLabel.text = "Public Repos"
            break
        case .gists:
            symbolimageView.image = UIImage(named: SFSymbols.gists)
            titleLabel.text = "Public Gists"
            break
        case .following:
            symbolimageView.image = UIImage(named: SFSymbols.following)
            titleLabel.text = "Following"
            break
        }
    }
    
}
