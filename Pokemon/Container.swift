//
//  Container.swift
//  Pokemon
//
//  Created by Mduduzi Mthethwa on 2024/01/30.
//

import Foundation
import Swinject

class DependencyManager {
    let container: Container
    
    init() {
        container = Container()
        container.register(PokemonService.self) { _ in PokemonServiceImplementation() }
        container.register(PokemonRepository.self) { _ in PokemonRepositoryImplementation() }
        container.register(PokemonDetailsService.self) { _ in PokemonDetailsServiceImplementation() }
        container.register(PokemonDetailsRepository.self) { _ in PokemonDetailsRepositoryImplementation() }
    }
    
    func resolvePokemonRepository() -> PokemonRepository {
        return container.resolve(PokemonRepository.self)!
    }
    
    func resolvePokemonService() -> PokemonService {
        return container.resolve(PokemonService.self)!
    }
    
    func resolvePokemonDetailsService() -> PokemonDetailsService {
        return container.resolve(PokemonDetailsService.self)!
    }
    
    func resolvePokemonDetailsRepository() -> PokemonDetailsRepository {
        return container.resolve(PokemonDetailsRepository.self)!
    }
    
    
}
