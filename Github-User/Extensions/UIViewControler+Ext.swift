//
//  UIViewControler+Ext.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-08.
//

import UIKit

extension UIViewController {
    func presentGFAlertOnMainThred(title: String, message: String, buttonTitle: String) {
        let alertVC = GFAlertVC(title: title, body: message, buttonTitle: buttonTitle)
        DispatchQueue.main.async {
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
