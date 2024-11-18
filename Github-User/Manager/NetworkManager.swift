//
//  NetworkManager.swift
//  Github-User
//
//  Created by Nastya Klyashtorna on 2024-11-08.
//

import UIKit

enum NetworkError: Error {
    case overflow
    case invalidUrl
    case dataError
    case unableToDecode
    case badRequest
}

class NetworkManager {
    enum Endpoint {case users, followers }
    
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    private let baseURL = "https://api.github.com/"
    let perPage = 50
    
    private init() {}
    
    func followers(for username: String, page: Int, completed: @escaping (Result<[Follower], NetworkError>) -> Void) {
        let endpoint = baseURL + "users/\(username)/followers?per_page=\(perPage)&page=\(page)"
//         e.g. https://api.github.com/users/Nastyanastya102/followers?per_page=50&page=1
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(NetworkError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(NetworkError.badRequest))
                return
            }
            
            guard let data = data else {
                completed(.failure(NetworkError.dataError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                let error = NetworkError.badRequest
                completed(.failure(error))
                return
            }
            
            do {
               let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decoded = try decoder.decode([Follower].self, from: data)
                completed(.success(decoded))
            } catch {
                completed(.failure(NetworkError.unableToDecode))
            }
        }
        
        task.resume()
    }
    
    func getUser(for username: String, completed: @escaping (Result<User, NetworkError>) -> Void) {
        let endpoint = baseURL + "users/\(username)"
//         e.g. https://api.github.com/users/Nastyanastya102
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(NetworkError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(NetworkError.badRequest))
                return
            }
            
            guard let data = data else {
                completed(.failure(NetworkError.dataError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                let error = NetworkError.badRequest
                completed(.failure(error))
                return
            }
            
            do {
               let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decoded = try decoder.decode(User.self, from: data)
                completed(.success(decoded))
            } catch {
                completed(.failure(NetworkError.unableToDecode))
            }
        }
        
        task.resume()
    }
}
