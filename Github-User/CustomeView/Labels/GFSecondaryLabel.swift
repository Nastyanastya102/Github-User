//
//  CFSecondaryLabel.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-17.
//

import UIKit

class GFSecondaryLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGFloat) {
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: size, weight: .medium)
        
        configure()
    }
    
    private func configure() {
        textColor = .gray
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
    }
}
