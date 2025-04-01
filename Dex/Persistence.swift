//
//  Persistence.swift
//  Dex
//
//  Created by Jim Rainville on 2/26/25.
//

import SwiftData
import Foundation

@MainActor
struct PersistenceController {

    static var previewPokemon: Pokemon {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let pokemonData = try! Data(String(contentsOf: Bundle.main.url(forResource: "samplepokemon", withExtension: "json")))
        
        let pokemon = try! decoder.decode(Pokemon.self, from: pokemonData)
        
        return pokemon
    }
    
    // @MainActor
    // This one is just for the preview.
    // Core data makes strings and URLs optional so we will need to deal with that in our code.
    static let preview: ModelContainer = {
        let container = try! ModelContainer(for: Pokemon.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        container.mainContext.insert(previewPokemon)
        
        return container
    }()
    
}
