//
//  TricksView.swift
//  WakeMaster
//
//  Created by Mischa Saleh on 05.09.25.
//

import SwiftUI
import Foundation
import Playgrounds

// MARK: - Modell
class Trick: Identifiable {
    let id: Int
    let name: String
    let description: String
    let progressionLevel: ProgressionLevel
    let category: TrickCategory
    let edgeType: String
    let rotationDirection: String
    let videoID: String

    init?(csvLine: String) {
        let regex = try! NSRegularExpression(pattern: //#"(?:^|,)(\"(?:[^\"]|\"\")*\"|[^,]*)"#) // CSV mit , getrennt
            #"(?:^|;)(\"(?:[^\"]|\"\")*\"|[^;]*)"#) //CSV mit ; getrennt
        let matches = regex.matches(in: csvLine, range: NSRange(csvLine.startIndex..., in: csvLine))
        let components = matches.map { match -> String in
            let range = Range(match.range(at: 1), in: csvLine)!
            var value = String(csvLine[range])
            if value.hasPrefix("\"") && value.hasSuffix("\"") {
                value = String(value.dropFirst().dropLast())
            }
            return value.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        guard components.count >= 7,
              let csvId = Int(components[0]),
              let level = ProgressionLevel(rawValue: components[3]), let tc = TrickCategory(rawValue: components[4]) else { return nil }
        self.id = csvId
        self.name = components[1]
        self.description = components[2]
        self.progressionLevel = level
        self.category = tc
        self.edgeType = components[5]
        self.rotationDirection = components[6]
        self.videoID = components[7]
    }
    enum TrickCategory : String, CaseIterable, Comparable, MyEnumProtocol{
        case basics = "Basics"
        case air = "Air"
        case grabs = "Grabs"
        case spins = "Spins"
        case raley = "Raley"
        case backRoll = "Back Roll"
        case frontFlip = "Front Flip"
        case frontRoll = "Front Roll"
        case tantrum = "Tantrum"
        case whip = "Whip"
        case rails = "Rails"
        
        var color: Color {
            switch self {
            default: return .secondary
            }
        }
        var sortOrder: Int {
            switch self {
            case .basics: return 0
            case .air: return 1
            case .grabs: return 2
            case .rails: return 3
            case .spins: return 4
            case .raley: return 5
            case .backRoll: return 6
            case .frontFlip: return 7
            case .frontRoll: return 8
            case .tantrum: return 9
            case .whip: return 10
            }
        }
        var symbol: String {
            switch self {
            default: return "tray.fill"
            }
        }
        static func < (lhs: TrickCategory, rhs: TrickCategory) -> Bool {
            lhs.sortOrder < rhs.sortOrder
        }
    }
    
    enum ProgressionLevel : String, CaseIterable, Comparable, MyEnumProtocol{
        case beginner = "Beginner"
        case advanced = "Advanced"
        case pro = "Pro"
        case expert = "Expert"

        var sortOrder: Int {
            switch self {
            case .beginner: return 0
            case .advanced: return 1
            case .pro: return 2
            case .expert: return 3
            }
        }
        var color: Color {
            switch self {
            case .beginner: return .mint
            case .advanced: return .cyan
            case .pro: return .purple
            case  .expert: return .pink
            }
        }
        var symbol: String {
            switch self {
            case .beginner: return "tortoise.fill"
            case .advanced: return "hare.fill"
            case .pro: return "bolt.fill"
            case  .expert: return "crown.fill"
            }
        }
        
        static func < (lhs: ProgressionLevel, rhs: ProgressionLevel) -> Bool {
            lhs.sortOrder < rhs.sortOrder
        }
    }
    
}

// MARK: - CSV Loader
func loadTricksFromCSV() -> [Trick] {
    guard let path = Bundle.main.path(forResource: "tricks 2", ofType: "csv") else {
        print("CSV file not found")
        return []
    }

    do {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        let lines = data.components(separatedBy: "\n")
        var tricks: [Trick] = []
        for line in lines.dropFirst() {
            
            if let trick = Trick(csvLine: line) {
                tricks.append(trick)
            }
        }
        return tricks
    } catch {
        print("Error reading CSV: \(error)")
        return []
    }
}

#Playground {
    loadTricksFromCSV()[92]
}
// MARK: - TricksView
struct TricksView: View {
    let tricks: [Trick] = loadTricksFromCSV()

    // Gruppierte Tricks nach Schwierigkeitsgrad
    var tricksByLevel: [Trick.ProgressionLevel: [Trick]] {
        Dictionary(grouping: tricks, by: { $0.progressionLevel })
    }

    var sortedLevels: [Trick.ProgressionLevel] {
        Trick.ProgressionLevel.allCases
            .filter { tricksByLevel.keys.contains($0) }
            .sorted()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(sortedLevels, id: \.self) { level in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Image(systemName: iconName(for: level))
                                    .imageScale(.large)
                                    .foregroundColor(color(for: level))
                                Text(level.rawValue)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.primary)
                            }
                            .padding(.leading, 5)

                            // Tricks für diese Stufe
                            ForEach(tricksByLevel[level] ?? []) { trick in
                                NavigationLink(destination: TrickDetailView(trick: trick)) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(trick.name)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            Text(trick.category.rawValue)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.primary)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color(.secondarySystemGroupedBackground))
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .background(Color(.systemBlue).opacity(0.2))
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Tricks")
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}
// MARK: - Icon + Farbe pro Level
func iconName(for level: Trick.ProgressionLevel) -> String {
    switch level {
    case .beginner: return "tortoise.fill"
    case .advanced: return "hare.fill"
    case .pro: return "bolt.fill"
    case .expert: return "crown.fill"
    }
}

func color(for level: Trick.ProgressionLevel) -> Color {
    switch level {
    case .beginner: return .green
    case .advanced: return .orange
    case .pro: return .red
    case .expert: return .purple
    }
}

// MARK: - Preview
#Preview {
    TricksView()
}
