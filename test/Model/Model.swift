//
//  Model.swift
//  test
//
//  Created by Vermut xxx on 28.11.2023.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMEpisode]
}
struct RMEpisode: Codable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}

struct RMCharacterResponse: Codable {
    let image: String
    let name: String
}

struct RMCharacter: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    struct Origin: Codable {
        let name: String
        let url: String
    }
    
    struct Location: Codable {
        let name: String
        let url: String
    }
}

struct NetworkManager {
    
    let sessionConfiguration = URLSessionConfiguration.default
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    func obtainEpisodes(completion: @escaping ([RMEpisode]) -> Void) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/episode") else { return }
        
        session.dataTask(with: url) { (data, response, error) in
            
            if error == nil, let data = data {
                
                if let episodesResponse = try? self.decoder.decode(RMGetAllEpisodesResponse.self, from: data) {
                    completion(episodesResponse.results)
                }
                
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }.resume()
    }
    
    func obtainCharacterImage(from url: String, completion: @escaping (String) -> Void) {
        guard let characterURL = URL(string: url) else { return }
        
        session.dataTask(with: characterURL) { (data, response, error) in
            if error == nil, let data = data {
                
                if let characterResponse = try? self.decoder.decode(RMCharacterResponse.self, from: data) {
                    completion(characterResponse.image)
                }
                
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }.resume()
    }
    
    func obtainCharacterName(from url: String, completion: @escaping (String) -> Void) {
        guard let characterURL = URL(string: url) else { return }
        
        session.dataTask(with: characterURL) { (data, response, error) in
            if error == nil, let data = data {
                
                if let characterResponse = try? self.decoder.decode(RMCharacterResponse.self, from: data) {
                    completion(characterResponse.name)
                }
                
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }.resume()
    }
    
    func obtainCharacter(from url: String, completion: @escaping (RMCharacter) -> Void) {
        guard let characterURL = URL(string: url) else { return }
        
        session.dataTask(with: characterURL) { (data, response, error) in
            if error == nil, let data = data {
                
                if let characterResponse = try? self.decoder.decode(RMCharacter.self, from: data) {
                    completion(characterResponse)
                }
                
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }.resume()
    }
    
}

