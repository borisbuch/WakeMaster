//
//  Ringview.swift
//  WakeMaster
//
//  Created by Boris on 29.03.26.
//

import SwiftUI
import SwiftData

struct RingView: View {
    @State private var service = TrickService()
    @Query private var trickProgress: [TrickProgress]

    
    var body: some View {
        let levels = Array(Trick.ProgressionLevel.allCases)
        let valueDict = service.getProgressionStats(trickProgress: trickProgress)

        return ZStack {
            ForEach(levels.indices, id: \.self) { index in
                let level = levels[levels.count - index - 1]
                let percent = (valueDict[level] ?? 0) / 100
                ZStack {
                    Circle()
                        .stroke(.gray.opacity(0.3), lineWidth: 20)
                    Circle()
                        .trim(from: 0, to: percent)
                        .stroke(level.color, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(-90))
                }
                .padding(CGFloat(index) * 32)
            }
        }
    }
    
}

#Preview {
    RingView()
        .padding()
}
