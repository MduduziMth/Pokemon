//
//  Pokemon.swift
//  Pokemon
//
//  Created by Mduduzi Mthethwa on 2024/01/27.
//

import Foundation
struct Pokemon: Codable {
    let name: String
    let url: String
    var id: Int {
        let components = url.components(separatedBy: "/")
        return Int(components[components.count - 2]) ?? 0
    }
}

struct PokemonResults: Codable {
    let results: [Pokemon]
}

struct PokemonList {
    let name : String
    let imageUrl: URL
    let id: Int
}

struct PokemonDetail: Codable {
    let base_experience: Int
    let weight: Int
    let height: Int
    let sprites: Sprites
}

struct Sprites: Codable {
    let front_default: String
    let other: Other
}

struct Other: Codable {
    let dream_world: DreamWorld
}

struct DreamWorld: Codable {
    let front_default: String
}

struct Constants {
    static let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
}


