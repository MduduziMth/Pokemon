//
//  PokemonRepository.swift
//  Pokemon
//
//  Created by Mduduzi Mthethwa on 2024/01/27.
//
// PokemonRepository.swift
protocol PokemonRepository {
    func getPokemons(offset: Int, limit: Int, completion: @escaping (Result<[PokemonList], Error>) -> Void)
}

class PokemonRepositoryImplementation: PokemonRepository {
    let dependencyContainer = DependencyManager()
    lazy var pokemonService: PokemonService = dependencyContainer.resolvePokemonService()
    
    func getPokemons(offset: Int, limit: Int, completion: @escaping (Result<[PokemonList], Error>) -> Void) {
        pokemonService.getPokemons(offset: offset, limit: limit, completion: completion)
    }
}
