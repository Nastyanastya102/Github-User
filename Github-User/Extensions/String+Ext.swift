//
//  String+Ext.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-18.
//

import Foundation

extension String {
    func convertToDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter.date(from: self)
    }
    
    func convertToDisplayString() -> String {
        return convertToDate()?.convertToString(format: "dd.MM.yyyy") ?? self
    }
}
