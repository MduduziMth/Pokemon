//
//  PokemonDetailViewModel.swift
//  Pokemon
//
//  Created by Mduduzi Mthethwa on 2024/01/30.
//

import Foundation
protocol PokemonDetailedDataViewModelDelegate: AnyObject {
    func pokemonDataFetchFailed(with error: Error)
    func pokemonDataFetchStarted()
    func pokemonDataFetched()
}
class PokemonDetailViewModel {
    weak var delegate: PokemonDetailedDataViewModelDelegate?
    let dependencyContainer = DependencyManager()
    lazy var repository: PokemonDetailsRepository = dependencyContainer.resolvePokemonDetailsRepository()
    var pokemon : PokemonDetail?
    var favouritePokemons: [String: Bool] {
        get {
            return UserDefaults.standard.dictionary(forKey: "FavouritePokemons") as? [String: Bool] ?? [:]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "FavouritePokemons")
        }
    }
    
    init(pokemonId: Int) {
        self.repository = repository
        fetchPokemonDetail(by: pokemonId) { [weak self] pokemon in
            self?.pokemon = pokemon
        }
    }
    
    private func fetchPokemonDetail(by id: Int, completion: @escaping (PokemonDetail?) -> Void) {
        repository.getPokemonDetail(by: id) { result in
            switch result {
            case .success(let pokemon):
                DispatchQueue.main.async {
                    completion(pokemon)
                    self.delegate?.pokemonDataFetched()
                }
            case .failure(let error):
                
                DispatchQueue.main.async {
                    completion(nil)
                    self.delegate?.pokemonDataFetchFailed(with: error)
                }
            }
        }
    }
    
    func isFavourite(pokemonId: Int) -> Bool {
        return favouritePokemons[String(pokemonId)] ?? false
    }
    
    func updateFavouriteStatus(for pokemonId: Int, isFavourite: Bool) {
        if isFavourite {
            favouritePokemons[String(pokemonId)] = true
        } else {
            favouritePokemons.removeValue(forKey: String(pokemonId))
        }
        UserDefaults.standard.set(favouritePokemons, forKey: "FavouritePokemons")
    }
    
    
}


