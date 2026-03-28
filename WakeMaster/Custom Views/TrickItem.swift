//
//  TrickItem.swift
//  WakeMaster
//
//  Created by Boris on 23.03.26.
//

import SwiftUI
import SwiftData

///Rounded Rectangle Item for each trick to be displayed in the GridTrickView
///- When tapped, it leads you to the ``TrickDetailView``.
struct TrickItem: View {
    ///The trick shown in the TrickItem
    var trick: Trick
    ///Gets the swiftData list, wich stores the status/progression of the trick
    @Query private var trickProgress: [TrickProgress]
    
    var body: some View {
        HStack {
            VStack {
                //Name
                HStack {
                    Text(trick.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                //Category
                HStack {
                    Text(trick.category.rawValue)
                        .font(.subheadline)
                        .foregroundStyle(trick.category.color)
                    Spacer()
                }
                Spacer()
            }
            .padding([.top, .leading], 3)
            Spacer()
            //Button
            VStack {
                TrickItemButton(trick: trick)
                Spacer()
            }
        }
        .padding(15)
        .background(RoundedRectangle(cornerRadius: 25).fill(trick.progressionLevel.color))
        .frame(height: 116)
        //Longpress Menu
        .contextMenu{
            //Gets the item from swiftData through checking for the same trickID, because the changeable Data like the Status is stored in SwiftData
            if let progress = trickProgress.first(where: { $0.trickID == trick.id }) {
                //The picker for the different states. It has to know what to do when showing the menu (get) and what to do when choosing one state in the menu (set)
                Picker("Sort", selection: Binding(
                    get: { progress.status },
                    set: { progress.status = $0 }
                )) {
                    //creates the different options
                    ForEach(Status.allCases, id: \.self) { status in
                        Label(status.rawValue, systemImage: status.symbol).tag(status)
                    }
                }
            }
        }
    }
}
#Preview {
    let trick: Trick = loadTricksFromCSV()[56] //Sample Data for the preview
    TrickItem(trick: trick)
        .frame(width: 190)
}
