//
//  UIView+Ext.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-26.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
