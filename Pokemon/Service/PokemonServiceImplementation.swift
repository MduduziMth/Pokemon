//
//  PokemonService.swift
//  Pokemon
//
//  Created by Mduduzi Mthethwa on 2024/01/27.
//
// PokemonService.swift
import Foundation

protocol PokemonService {
    func getPokemons(offset: Int, limit: Int, completion: @escaping (Result<[PokemonList], Error>) -> Void)
}

class PokemonServiceImplementation: PokemonService {
    private let baseURL = Constants.baseURL
    
    func getPokemons(offset: Int = 0, limit: Int = 5, completion: @escaping (Result<[PokemonList], Error>) -> Void) {
        let url = URL(string: "\(baseURL)?offset=\(offset)&limit=\(limit)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found"])))
                return
            }
            
            do {
                let pokemonResponse = try JSONDecoder().decode(PokemonResults.self, from: data)
                let pokemonList = pokemonResponse.results.map {
                    PokemonList(name: $0.name,
                                imageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\($0.id).png")!,
                                id: $0.id)
                }
                completion(.success(pokemonList))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
