//
//  DexApp.swift
//  Dex
//
//  Created by Jim Rainville on 2/26/25.
//

import SwiftUI
import SwiftData

@main
struct DexApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Pokemon.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}

/*
 Coding Challenges:
 ✅ Show shiny's on list - add toggle on list that toggles between showing normal and shiny sprites.
 * Filter by type - similiar to what we did on the apex predetors app
 * show all sprites - make sprite on detail screen tappable and when tapped goes to a screen that shows all possible sprites (or at least more then two)
 * show all possible moves - get more api data. Put disclosure group under the stats on the detail screen that will show all the possible moves for that pokemon. Can also show types of moves. 
 */
