//
//  UIHelper.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-11.
//
import UIKit

struct UIHelper {
    static func createThereCollectionFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let avaiableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = avaiableWidth / 3
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return layout
    }
}
