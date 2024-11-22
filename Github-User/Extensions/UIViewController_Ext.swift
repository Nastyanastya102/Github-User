//
//  UIViewController_Ext.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-12.
//
fileprivate var containerView: UIView!

import UIKit

extension UIViewController {
    func presentGFAlertOnMainThred(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alert = GFAlertVC(title: title, body: message, buttonTitle: buttonTitle)
            alert.modalTransitionStyle = .crossDissolve
            alert.modalPresentationStyle = .overFullScreen

            self.present(alert, animated: true)
        }
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            [weak containerView] in
            containerView?.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingViewHandler() {
        DispatchQueue.main.async {
            containerView?.removeFromSuperview()
            containerView = nil
        }
    }
    
    func showEmptyView(with message: String, in view: UIView) {
        let emptyView = GFEmptyState(message: message)
        emptyView.frame = view.bounds
        view.addSubview(emptyView)
    }
}
