//
//  SectionHeaderView.swift
//  WakeMaster
//
//  Created by Boris on 27.03.26.
//

import SwiftUI

struct SectionHeaderView: View {
    var category: any MyEnumProtocol
    var body: some View {
        GlassEffectContainer {
            Label{
                Text(category.rawValue)
            } icon: {
                Image(systemName: category.symbol)
                    .foregroundStyle(category.color)
            }
            .font(.title2)
            .padding()
        }
        .background(RoundedRectangle(cornerRadius: 100, style: .continuous)
            .fill(.background)
            )
        //.background(RoundedRectangle(cornerRadius: 100).fill(.primary)
            //.colorInvert()
            //.blur(radius: 20, opaque: false)
            //.opacity()
           // .glassEffect())
    }
}

#Preview {
    let trick: Trick = loadTricksFromCSV()[7] // Sample Data
    SectionHeaderView(category: trick.progressionLevel)
        
        
}
