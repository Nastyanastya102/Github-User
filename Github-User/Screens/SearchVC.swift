//
//  SearchVC.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-05.
//

import UIKit

class SearchVC: UIViewController {
    let logoImageView = UIImageView()
    let userNameTextFileld = GFTextField()
    let searchButton = GFButton(backgroundColor: .systemGreen, title: "Get followers")
    let activityIndicator = UIActivityIndicatorView()
    private let line: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "line")
        return imageView
    }()

    private let descText: GFBodyLabel = {
        let label = GFBodyLabel()
        label.text = "Github Users App"
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    
    var isUserNameEntered: Bool {return !userNameTextFileld.text!.isEmpty}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Why here it's view and in button and text field it's layer?
      
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        userNameTextFileld.text = ""
        view.addSubview(logoImageView)
        stackView.addArrangedSubview(line)
        stackView.addArrangedSubview(descText)
        view.addSubview(stackView)
        
        configureLogoImageView()
        configureTextField()
        configureButton()
        createDismissTapGesture()
        configureDescription()
    }
    
    func configureDescription() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: userNameTextFileld.bottomAnchor, constant: 80),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            stackView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        NSLayoutConstraint.activate([
               line.widthAnchor.constraint(equalToConstant: 50), // Example constraint
               line.heightAnchor.constraint(equalToConstant: 50) // Example constraint
           ])
    }
    
    func configureLogoImageView () {
        logoImageView.image = UIImage(named: "gh-logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func configureTextField() {
        view.addSubview(userNameTextFileld)
        userNameTextFileld.delegate = self
        
        NSLayoutConstraint.activate([
            userNameTextFileld.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextFileld.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextFileld.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameTextFileld.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func configureButton() {
        view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(pushFollowerList), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            ])
       }
    
    func createDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func pushFollowerList () {
        
        guard isUserNameEntered else {
            presentGFAlertOnMainThred(title: "Empty username 🥲", message: "Please enter a username to search for", buttonTitle: "Ok")
            return
        }
        userNameTextFileld.resignFirstResponder()
        let followerListVC = FollowersListVC()
        followerListVC.userName = userNameTextFileld.text!
        followerListVC.title = userNameTextFileld.text
        navigationController?.pushViewController(followerListVC, animated: true)
        userNameTextFileld.text = ""
    }

}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerList()
        return true
    }
}
