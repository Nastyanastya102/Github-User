//
//  GFItemInfoVCViewController.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-18.
//

import UIKit

class GFItemInfoVCViewController: UIViewController {
    let stackView = UIStackView()
    let infoView = GFInfoView()
    let infoView2 = GFInfoView()
    let actionButton = GFButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        layoutUI()
        configureStackView()
    }
    
    private func configureBackground() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func layoutUI () {
        let padding: CGFloat = 20
        view.addSubview(stackView)
        view.addSubview(actionButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(infoView)
        stackView.addArrangedSubview(infoView2)
    }

}
