//
//  PokemonDetailRepository.swift
//  Pokemon
//
//  Created by Mduduzi Mthethwa on 2024/01/30.
//

import Foundation

protocol PokemonDetailsRepository {
    func getPokemonDetail(by id: Int, completion: @escaping (Result<PokemonDetail, Error>) -> Void)
}

class PokemonDetailsRepositoryImplementation: PokemonDetailsRepository {
    let dependencyContainer = DependencyManager()
    lazy var pokemonService: PokemonDetailsService  = dependencyContainer.resolvePokemonDetailsService()
    
    
    func getPokemonDetail(by id: Int, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        pokemonService.getPokemonById(id: id, completion: completion)
    }
}
