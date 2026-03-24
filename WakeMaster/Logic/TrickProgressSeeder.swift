//
//  TrickProgressSeeder.swift
//  WakeMaster
//
//  Created by Boris on 24.03.26.
//

import SwiftData

struct TrickProgressSeeder {
    static func createMissingProgressEntries(
        for tricks: [Trick],
            existingProgress: [TrickProgress],
            modelContext: ModelContext
    ) {
        let existingIDs = Set(existingProgress.map(\.trickID))
        
        for trick in tricks where !existingIDs.contains(trick.id) {
            let newProgress = TrickProgress(trickID: trick.id)
            modelContext.insert(newProgress)
        }
    }
}
