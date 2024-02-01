//
//  PokemonDetailsService.swift
//  Pokemon
//
//  Created by Mduduzi Mthethwa on 2024/01/30.
//

import Foundation
protocol PokemonDetailsService {
    func getPokemonById(id: Int, completion: @escaping (Result<PokemonDetail, Error>) -> Void)
}

class PokemonDetailsServiceImplementation: PokemonDetailsService {
    private let baseURL = Constants.baseURL
    
    func getPokemonById(id: Int, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(id)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let pokemon = try decoder.decode(PokemonDetail.self, from: data)
                completion(.success(pokemon))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
