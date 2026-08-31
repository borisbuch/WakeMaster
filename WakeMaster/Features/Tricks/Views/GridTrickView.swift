//
//  GridTrickView.swift
//  WakeMaster
//
//  Created by Boris on 21.03.26.
//

import SwiftUI
import SwiftData

let tricks: [Trick] = loadTricksFromCSV()


struct GridTrickView: View {
//    @State private var filterDict: [Status:Binding<Bool>] = [.flagged : true,.landed: true, .notLanded: true]
    @State private var showLanded = true
    @State private var showFlagged = true
    @State private var showNotLanded = true
    @State var selectedSort: String = "difficulty ascending"
    @State private var searchField: String = ""
    @State private var service = TrickService()
    @Query private var trickProgress: [TrickProgress]
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12, alignment: .top), count: 2), spacing: 12) {
                    let filterList = [showNotLanded, showLanded, showFlagged]
                    switch service.groupType {
                    case .difficulty :
                        
                        let dict = service.groupedFilteredByProgressionLevel(searchField, trickProgress: trickProgress, filterList: filterList)
                        
                        ForEach(dict.keys.sorted(), id: \.self) { category in
                            if let items = dict[category] {
                                Section(header: SectionHeaderView(category: category)) {
                                    ForEach(items) { trick in
                                        NavigationLink(destination: TrickDetailView(trick: trick))
                                        {
                                            TrickItem(trick: trick)
                                        }
                                    }
                                }
                            }
                        }
                    case .category :
                        
                        let dict = service.groupedFilteredByCategory(searchField, trickProgress: trickProgress, filterList: filterList)
                        
                        ForEach(dict.keys.sorted(), id: \.self) { category in
                            if let items = dict[category] {
                                Section (header: SectionHeaderView(category: category)){
                                    ForEach(items) { trick in
                                        NavigationLink(destination: TrickDetailView(trick: trick))
                                        {
                                            TrickItem(trick: trick)
                                        }
                                    }
                                }
                            }
                        }
                    case .status :
                        
                        let dict = service.groupedFilteredByStatus(searchField, trickProgress: trickProgress, filterList: filterList)
                        
                        ForEach(dict.keys.sorted(), id: \.self) { category in
                            if let items = dict[category] {
                                Section (header: SectionHeaderView(category: category)) {
                                    ForEach(items) { trick in
                                        NavigationLink(destination: TrickDetailView(trick: trick))
                                        {
                                            TrickItem(trick: trick)
                                        }
                                    }
                                }
                            }
                        }
                    default:
                        
                        let list = service.itemsFilteredBy(searchField)
                        
                        
                                    ForEach(list) { trick in
                                        NavigationLink(destination: TrickDetailView(trick: trick)) {
                                            TrickItem(trick: trick)
                                        }
                                    }
                             
                        
                    }
                }
                .padding(15)

            }
            .navigationTitle("Tricks")
            .toolbarTitleDisplayMode(.inlineLarge)
            .searchable(text: $searchField, placement: .navigationBarDrawer, prompt: "Filter by Name")
            .toolbar{
                //Toolbar Menu
                ToolbarItem(placement: .topBarTrailing) {

                    Menu("TricksMenu", systemImage: "ellipsis") {
                        Menu("Group", systemImage: "square.grid.3x1.below.line.grid.1x2.fill") {
                            Picker("Sort", selection: $service.groupType) {
                                ForEach(TrickService.GroupType.allCases, id: \.self) { groupType in
                                    Text(groupType.rawValue)
                                        .tag(groupType)
                                    
                                                }
                                            }
                        }
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Button(service.sortOrderTxt) {
                                service.reverseSortOrder()
                            }
                            Picker("Sort", selection: $service.sortType) {
                                ForEach(TrickService.SortType.allCases, id: \.self) { sortType in
                                    Text(sortType.title)
                                        .tag(sortType)
                                    
                                                }
                                            }
                            
                        }
                        Menu("Filter", systemImage: "line.3.horizontal.decrease") {
                            Toggle("Flagged Tricks", isOn: $showFlagged)
                            Toggle("Landed Tricks", isOn: $showLanded)
                            Toggle("Not Landed Tricks", isOn: $showNotLanded)
                            
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        GridTrickView()
            .modelContainer(for: TrickProgress.self, inMemory: true)
    }
}

