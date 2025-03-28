//
//  Pokemon.swift
//  Dex
//
//  Created by Jim Rainville on 3/28/25.
//
//

import Foundation
import SwiftData
import SwiftUI


@Model
class Pokemon: Decodable {
    // #Unique<Pokemon>([\.id]) Either do this or the @Attribute below.
    @Attribute(.unique) var id: Int
    var name: String
    var types: [String]
    var hp: Int
    var attack: Int
    var defense: Int
    var specialAttack: Int
    var specialDefense: Int
    var speed: Int
    var spriteURL: URL
    var shinyURL: URL
    var sprite: Data?
    var shiny: Data?
    var favorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypeDictionaryKeys: CodingKey {
            case type
            enum TypeKeys: CodingKey {
                case name
            }
        }
        enum StatDictionaryKeys: CodingKey {
            case baseStat
        }
        
        enum SpriteKeys: String, CodingKey {
            case spriteURL = "frontDefault"
            case shinyURL = "frontShiny"
        }
        
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        var decodedTypes: [String] = []
        // Keyed container is a dictionary, unkeyed containers are arrays.
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        
        
        if decodedTypes.count == 2 && decodedTypes[0] == "normal" {
            /*
             let tempType = decodedTypes[0]
             decodedTypes[0] = decodedTypes[1]
             decodedTypes[1] = tempType
             */
            // This is a shortcut for doing the above.
            decodedTypes.swapAt(0, 1)
        }
        
        
        types = decodedTypes
        
        var decodedStats: [Int] = []
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: CodingKeys.StatDictionaryKeys.self)
            let stat = try statsDictionaryContainer.decode(Int.self, forKey: .baseStat)
            decodedStats.append(stat)
        }
        hp = decodedStats[0]
        attack = decodedStats[1]
        defense = decodedStats[2]
        specialAttack = decodedStats[3]
        specialDefense = decodedStats[4]
        speed = decodedStats[5]
        
        
        let spritesContainer = try container.nestedContainer(keyedBy: CodingKeys.SpriteKeys.self, forKey: .sprites)
        spriteURL = try spritesContainer.decode(URL.self, forKey: .spriteURL)
        shinyURL = try spritesContainer.decode(URL.self, forKey: .shinyURL)
    }
    
    var spriteImage: Image {
        if let data = sprite, let image = UIImage(data: data) {
            Image(uiImage: image)
        } else {
            Image(.bulbasaur)
        }
    }
    
    var shinyImage: Image {
        if let data = shiny, let image = UIImage(data: data) {
            Image(uiImage: image)
        } else {
            Image(.shinybulbasaur)
        }
    }
    
    var background: ImageResource {
        switch types[0] {
        case "rock", "ground", "steel", "fighting", "ghost", "dark", "psychic":
                .rockgroundsteelfightingghostdarkpsychic
        case "fire", "dragon":
                .firedragon
        case "flying", "bug":
                .flyingbug
        case "ice":
                .ice
        case "water":
                .water
        default:
                .normalgrasselectricpoisonfairy
        }
    }
    
    var typeColor: Color {
        Color(types[0].capitalized)
    }
    
    // This is needed so we can print the name of the stat and also for ordering.
    var stats: [Stat] {
        [
            Stat(id: 1, name: "HP", value: hp),
            Stat(id: 2, name: "Attack", value: attack),
            Stat(id: 3, name: "Defense", value: defense),
            Stat(id: 4, name: "Special Attack", value: specialAttack),
            Stat(id: 5, name: "Special Defense", value: specialDefense),
            Stat(id: 6, name: "Speed", value: speed)
        ]
    }
    
    var highestStat: Stat {
        stats.max { $0.value < $1.value}!
    }
    
}

struct Stat: Identifiable {
    let id: Int
    let name: String
    let value: Int
}
