//
//  TrickService.swift
//  WakeMaster
//
//  Created by Boris on 22.03.26.
//

import SwiftUI
import Playgrounds

@Observable
class TrickService {
    var trickItems: [Trick]
    var sortOrder: SortOrder = .forward
    var sortType: SortType = .difficulty
    var groupType: GroupType = .difficulty
    let statusList: [Status] = [.notLanded, .landed, .flagged]
    
    enum GroupType: String, CaseIterable{
        case none = "None"
        case difficulty = "Difficulty"
        case category = "Category"
        case status = "Status"
    }
    
    var sortOrderTxt: String {
        switch sortOrder {
        case .forward:
            return "Ascending"
        case .reverse:
            return "Descending"
        }
    }
    
    enum SortType: CaseIterable {
        case difficulty
        case name
        
        var title: String {
            switch self {
            case .difficulty: return "Difficulty"
            case .name: return "Name"
            }
        }
        
        
    }
        
        var comparator: any SortComparator<Trick> {
            switch sortType {
            case .difficulty:
                return KeyPathComparator(\Trick.progressionLevel, order: sortOrder)
            case .name:
                return KeyPathComparator(\Trick.name, order: sortOrder)

            }
            
        }
    
        
        init() {
            trickItems = loadTricksFromCSV()
        }
    
    /// Switches between sortorder Ascending/Descending
    func reverseSortOrder() {
        if sortOrder == .forward{
            sortOrder = .reverse
        }else{
            sortOrder = .forward
        }
    }
        
        /// Gibt eine Sortierte und nach Suchbegriff gefilterte Liste von Tricks Zurück
        /// - Parameter filterString: Text nach dem gefiltert werden soll
        /// - Returns: Alle Tricks, die mit dem Suchbegriff übereinstimmen und sortiert
        func itemsFilteredBy(_ filterString: String) -> [Trick] {
            let strippedFilter = filterString.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !filterString.isEmpty else {
                return trickItems
                    .sorted(using: comparator)
            }
            return trickItems
                .filter{$0.name.localizedCaseInsensitiveContains(strippedFilter)}
                .sorted(using: comparator)
        }
    
        /// Gibt eine Sortierte und nach Suchbegriff gefilterte Liste von Tricks Zurück
        /// - Parameter filterString: Text nach dem gefiltert werden soll
        /// - Returns: Alle Tricks, die mit dem Suchbegriff übereinstimmen und sortiert
    func itemsFilteredByStatus(_ filterString: String, trickProgress: [TrickProgress], filterList : [Bool]) -> [Trick] {
            let strippedFilter = filterString.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !filterString.isEmpty else {
                return trickItems
                    .sorted(using: comparator)
                    .filter{
                        let trick = $0
                        let trickStatus = trickProgress.first(where: {$0.trickID == trick.id})?.status ?? .notLanded
                        let result = zip(statusList, filterList)
                            .filter {$0.1}
                            .map{$0.0}
                        return (result).contains(trickStatus)
                    }
            }
            return trickItems
                .filter{$0.name.localizedCaseInsensitiveContains(strippedFilter)}
                .filter{
                    let trick = $0
                    let trickStatus = trickProgress.first(where: {$0.trickID == trick.id})?.status ?? .notLanded
                    let result = zip(statusList, filterList)
                        .filter {$0.1}
                        .map{$0.0}
                    return (result).contains(trickStatus)
                }
                .sorted(using: comparator)
        }
        
    func groupedFilteredByProgressionLevel(_ filterString: String, trickProgress: [TrickProgress], filterList : [Bool]) -> [Trick.ProgressionLevel : [Trick]] {
        let filteredItems = itemsFilteredByStatus(filterString, trickProgress: trickProgress, filterList: filterList)
             return Dictionary(grouping: filteredItems, by: \.progressionLevel)
         }
    
    func groupedFilteredByCategory(_ filterString: String, trickProgress: [TrickProgress], filterList : [Bool]) -> [Trick.TrickCategory : [Trick]] {
             let filteredItems = itemsFilteredByStatus(filterString, trickProgress: trickProgress, filterList : filterList)
             return Dictionary(grouping: filteredItems, by: \.category)
         }
     
    func groupedFilteredByStatus(_ filterString: String, trickProgress: [TrickProgress], filterList : [Bool]) -> [Status : [Trick]] {
        let filteredItems = itemsFilteredByStatus(filterString, trickProgress: trickProgress, filterList: filterList)
        return Dictionary(grouping: filteredItems) { trick in
            trickProgress.first(where: {$0.trickID == trick.id})?.status ?? .notLanded
        }

         }

}


