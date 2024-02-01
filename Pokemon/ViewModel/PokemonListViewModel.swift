//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by Mduduzi Mthethwa on 2024/01/27.
//

import Foundation
import UIKit

protocol PokemonDataViewModelDelegate: AnyObject {
    func pokemonDataFetched(pokemons: [PokemonList])
    func pokemonDataFetchFailed(with error: Error)
    func pokemonDataFetchStarted()
}

class PokemonListViewModel {
    weak var delegate: PokemonDataViewModelDelegate?
    var pokemons: [PokemonList] = []
    
    let dependencyContainer = DependencyManager()
    lazy var pokemonRepository: PokemonRepository = dependencyContainer.resolvePokemonRepository()
    
    
    func fetchPokemons(with name: String = "", offset: Int = 0, limit: Int = 100) {//
        delegate?.pokemonDataFetchStarted()
        let lowercasedName = name.lowercased()
        pokemonRepository.getPokemons(offset: offset, limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemons):
                    self?.pokemons = lowercasedName.isEmpty ? pokemons : pokemons.filter { $0.name.lowercased().contains(lowercasedName) }
                    self?.delegate?.pokemonDataFetched(pokemons: self?.pokemons ?? [])
                case .failure(let error):
                    self?.delegate?.pokemonDataFetchFailed(with: error)
                }
            }
        }
    }
    
    func fetchImageData(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = ImageCache.shared.getImage(url: url) {
            completion(.success(cachedImage))
        } else {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    } else if let data = data, let image = UIImage(data: data) {
                        ImageCache.shared.setImage(image, for: url)
                        completion(.success(image))
                    }
                }
            }
            task.resume()
        }
    }
}
