//
//  GridTrickView.swift
//  WakeMaster
//
//  Created by Boris on 21.03.26.
//

import SwiftUI
let tricks: [Trick] = loadTricksFromCSV()


struct GridTrickView: View {
    @State private var showLanded = true
    @State private var showFlagged = true
    @State private var showNotLanded = true
    @State var selectedSort: String = "difficulty ascending"
    @State private var searchField: String = ""
    @State private var service = TrickService()
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12, alignment: .top), count: 2), spacing: 12) {
                    switch service.groupType {
                    case .difficulty :
                        
                        let dict = service.groupedFilteredByProgressionLevel(searchField)
                        
                        ForEach(dict.keys.sorted(), id: \.self) { category in
                            if let items = dict[category] {
                                Section {
                                    ForEach(items) { trick in
                                        NavigationLink(destination: TrickDetailView(trick: trick)) {
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(trick.progressionLevel.color)
                                                .frame(height: 116)
                                                .overlay(alignment: .topLeading) {
                                                    VStack(alignment: .leading, spacing: 6) {
                                                        Text(trick.name)
                                                            .foregroundColor(.white)
                                                            .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                                                        Text(trick.category.rawValue)
                                                            .foregroundStyle(.gray)
                                                    }
                                                    .padding(15)
                                                }
                                        }
                                    }
                                } header: {
                                    Label{
                                        Text(category.rawValue)
                                    } icon: {
                                        Image(systemName: category.symbol)
                                            .foregroundStyle(category.color)
                                    }
                                    .font(.title2)
                                }
                            }
                        }
                    case .category :
                        
                        let dict = service.groupedFilteredByCategory(searchField)
                        
                        ForEach(dict.keys.sorted(), id: \.self) { category in
                            if let items = dict[category] {
                                Section {
                                    ForEach(items) { trick in
                                        NavigationLink(destination: TrickDetailView(trick: trick)) {
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(trick.progressionLevel.color)
                                                .frame(height: 116)
                                                .overlay(alignment: .topLeading) {
                                                    VStack(alignment: .leading, spacing: 6) {
                                                        Text(trick.name)
                                                            .foregroundColor(.white)
                                                            .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                                                        Text(trick.category.rawValue)
                                                            .foregroundStyle(.gray)
                                                    }
                                                    .padding(15)
                                                }
                                        }
                                    }
                                } header: {
                                    Label{
                                        Text(category.rawValue)
                                    } icon: {
                                        Image(systemName: category.symbol)
                                            .foregroundStyle(.secondary)
                                    }
                                    .font(.title2)
                                }
                            }
                        }
                    default:
                        
                        let list = service.itemsFilteredBy(searchField)
                        
                        
                                    ForEach(list) { trick in
                                        NavigationLink(destination: TrickDetailView(trick: trick)) {
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(trick.progressionLevel.color)
                                                .frame(height: 116)
                                                .overlay(alignment: .topLeading) {
                                                    VStack(alignment: .leading, spacing: 6) {
                                                        Text(trick.name)
                                                            .foregroundColor(.white)
                                                            .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                                                        Text(trick.category.rawValue)
                                                            .foregroundStyle(.gray)
                                                    }
                                                    .padding(15)
                                                }
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
                            Toggle("Landed Tricks", isOn: $showLanded)
                            Toggle("Flagged Tricks", isOn: $showFlagged)
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
    }
}

