//
//  TrickItem.swift
//  WakeMaster
//
//  Created by Boris on 23.03.26.
//

import SwiftUI
import SwiftData

struct TrickItem: View {
    var trick: Trick
    var service: TrickService
    
    @Query private var trickProgress: [TrickProgress]
    
    var body: some View {
        ZStack{
        RoundedRectangle(cornerRadius: 25)
            .fill(trick.progressionLevel.color)
            .frame(height: 116)
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(trick.name)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                Spacer()
                TrickItemButton(trick: trick)
            }
                Text(trick.category.rawValue)
                    .foregroundStyle(.gray)
            Spacer()
        }.padding(15)
                

            
        }
        .contextMenu{
                if let progress = trickProgress.first(where: { $0.trickID == trick.id }) {
                    Picker("Sort", selection: Binding(
                        get: { progress.status },
                        set: { progress.status = $0 }
                    )) {
                        ForEach(Status.allCases, id: \.self) { status in
                            Label(status.rawValue, systemImage: status.symbol).tag(status)
                        }
                    }
                }
            }        

    }
}

