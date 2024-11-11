//
//  GFAvatartImageView.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-10.
//

import UIKit

class GFAvatartImageView: UIImageView {
    let placeholderImage = UIImage(named:  "avatar-placeholder")
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
    }
}
