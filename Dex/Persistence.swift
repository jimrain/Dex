//
//  Persistence.swift
//  Dex
//
//  Created by Jim Rainville on 2/26/25.
//

import CoreData

struct PersistenceController {
    // The controller is the thing that controls the database.
    static let shared = PersistenceController()

    static var previewPokemon: Pokemon {
       let context = PersistenceController.preview.container.viewContext
        
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let resutls = try! context.fetch(fetchRequest)
        return resutls.first!
    }
    
    // @MainActor
    // This one is just for the preview.
    // Core data makes strings and URLs optional so we will need to deal with that in our code.
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let newPokemon = Pokemon(context: viewContext)
        newPokemon.id = 1
        newPokemon.name = "bulbasaur"
        newPokemon.types = ["Grass", "Poison"]
        newPokemon.hp = 45
        newPokemon.attack = 49
        newPokemon.defense = 49
        newPokemon.specialAttack = 65
        newPokemon.specialDefense = 65
        newPokemon.speed = 45
        newPokemon.spriteURL =  URL(string:"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        newPokemon.shinyURL =  URL(string:"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png")

        do {
            try viewContext.save()
        } catch {
            print(error)
        }
        return result
    }()
    
    // The container is the database (where you put the data)
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Dex")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            container.persistentStoreDescriptions.first!.url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.net.rainville.DexGroup")!.appending(path: "Dex.sqlite")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error)
            }
        })
        
        // This merge policy means that if we have a conflict with an ID (since we marked it unique
        // keep the one that is stored in the database. 
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
