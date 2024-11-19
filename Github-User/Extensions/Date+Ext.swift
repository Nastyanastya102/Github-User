//
//  Date+Ext.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-18.
//

import Foundation

extension Date {
    func convertToString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
