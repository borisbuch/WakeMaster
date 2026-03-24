//
//  TrickItemButton.swift
//  WakeMaster
//
//  Created by Boris on 23.03.26.
//

import SwiftUI
import SwiftData
import Playgrounds

struct TrickItemButton: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var trickProgress: [TrickProgress]
    var trick: Trick
    var currentProgress: TrickProgress? {
        trickProgress.first(where: {$0.trickID == trick.id})
    }
    
    var currentStatus: Status {
        currentProgress?.status ?? .notLanded
    }
    var body: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
            
                    if let progress = currentProgress {
                        progress.status = progress.status.next
                    } else {
                        let newEntry = TrickProgress(trickID: trick.id)
                        modelContext.insert(newEntry)
                    }
                print(trickProgress)
                } label: {
                    Image(systemName: currentStatus.symbol)
                        .frame(width: 29, height: 29)
                        .clipShape(Circle())
                        .foregroundStyle(.black)
                        .background(Circle().fill(currentStatus.color))
                }
                
        .glassEffect()
    
    }
}

//#Preview {
//    TrickItemButton()
//        .modelContainer(for: TrickProgress.self, inMemory: true)
//}

