//
//  User.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-08.
//

import Foundation

struct User: Codable {
    var logic: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createdAt: String
}
