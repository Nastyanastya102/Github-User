//
//  PersistanceManager.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-20.
//

import Foundation

enum PersistanceActionType {
    case add
    case remove
}

enum PersistanceManager {
    static private let defaults = UserDefaults.standard
    enum Keys {
        static let favorites = "favorites"
    }
    static func retrivewFavoriteUsers(complete: @escaping (Result<[Follower], NetworkError>) -> Void) {
        guard let favoriteUsers = defaults.object(forKey: Keys.favorites) as? Data else {
            complete(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let users = try decoder.decode([Follower].self, from: favoriteUsers)
            complete(.success(users))
        } catch {
            complete(.failure(.unableToDecode))
        }
    }
    
    static func save(_ users: [Follower]) -> NetworkError? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(users)
            defaults.set(data, forKey: Keys.favorites)
            return nil
        } catch {
            print("Error encoding users: \(error)")
            return .unableToDecode
        }
    }
    
    static func updateFavorire(favorite: Follower, action: PersistanceActionType, completed: @escaping (NetworkError?) -> Void) {
        retrivewFavoriteUsers { result in
            switch result {
            case .success(let users):
                var favorites = users
                print(favorites)
                print(favorites.contains(favorite))
                guard !favorites.contains(favorite) else {
                    completed(.dataError)
                    return
                }
                
                action == .remove ? favorites.removeAll { $0.login == favorite.login } : favorites.append(favorite)
                
                completed(save(favorites))
            case .failure(let error):
                completed(error)
            }
        }
    }
}
