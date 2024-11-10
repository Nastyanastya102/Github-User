//
//  GFFollowerCellTableViewCell.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-09.
//

import UIKit

class GFFollowerCellTableViewCell: UITableViewCell {
    
    static let identifire: String = "GFFollowerCellTableViewCell"
    
    let customImageView = UIImageView()
    
    let customLabel =  UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }


    func configure(with image: String, text: String) {
//        if let imageURL = URL(string: image) {
//            customImageView.i
//            customImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "photo"))
//        } else {
//            customImageView.image = UIImage(systemName: "photo") // Placeholder if URL is invalid
//        }

        customLabel.text = text
    }
 
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureLabel(with text: String) {
        contentView.addSubview(customLabel)
        customLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        customLabel.textColor = .black
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 15),
            customLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func configureImage(with image: UIImage) {
        contentView.addSubview(customImageView)
        customImageView.contentMode = .scaleAspectFill
        customImageView.clipsToBounds = true
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            customImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customImageView.widthAnchor.constraint(equalToConstant: 50),
            customImageView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
