//
//  ContentView.swift
//  WakeMaster
//
//  Created by Mischa Saleh on 05.09.25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @State private var selectedTab = 1
    @Query private var trickProgress: [TrickProgress]
    @Environment(\.modelContext) private var modelContext
    private var tricks: [Trick] = loadTricksFromCSV()
    
    var body: some View {
        
        TabBar()
            .tabBarMinimizeBehavior(.onScrollDown)
            .task {
                TrickProgressSeeder.createMissingProgressEntries(for: tricks, existingProgress: trickProgress, modelContext: modelContext)
            }
        
        
    }
    
}


                


            #Preview {
                MainView()
                    .modelContainer(for: TrickProgress.self, inMemory: true)
            }
