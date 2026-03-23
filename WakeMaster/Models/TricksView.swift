//
//  TricksView.swift
//  WakeMaster
//
//  Created by Mischa Saleh on 05.09.25.
//

import SwiftUI

// MARK: - Modell
struct Trick: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let progressionLevel: ProgressionLevel
    let category: TrickCategory
    let edgeType: String
    let rotationDirection: String

    init?(csvLine: String) {
        let regex = try! NSRegularExpression(pattern: #"(?:^|,)(\"(?:[^\"]|\"\")*\"|[^,]*)"#)
        let matches = regex.matches(in: csvLine, range: NSRange(csvLine.startIndex..., in: csvLine))
        let components = matches.map { match -> String in
            let range = Range(match.range(at: 1), in: csvLine)!
            var value = String(csvLine[range])
            if value.hasPrefix("\"") && value.hasSuffix("\"") {
                value = String(value.dropFirst().dropLast())
            }
            return value.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        guard components.count >= 7, let level = ProgressionLevel(rawValue: components[3]), let tc = TrickCategory(rawValue: components[4]) else { return nil }
        self.name = components[1]
        self.description = components[2]
        self.progressionLevel = level
        self.category = tc
        self.edgeType = components[5]
        self.rotationDirection = components[6]
    }
    enum TrickCategory : String, CaseIterable, Comparable {
        case basics = "Basics"
        case air = "Air"
        case grabs = "Grabs"
        case spins = "Spins"
        case raley = "Raley"
        case backRoll = "Back Roll"
        case frontRoll = "Front Roll"
        case tantrum = "Tantrum"
        case whip = "whip"
        case rails = "Rails"
        
        var color: Color {
            switch self {
            default: return .primary
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
            case .frontRoll: return 7
            case .tantrum: return 8
            case .whip: return 9
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
    
    enum ProgressionLevel : String, CaseIterable, Comparable {
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
            case .pro: return .indigo
            case  .expert: return .purple
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
    guard let path = Bundle.main.path(forResource: "tricks", ofType: "csv") else {
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

// MARK: - DetailView
struct TrickDetailView: View {
    let trick: Trick
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Category: \(trick.category.rawValue)")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Edge Type: \(trick.edgeType)")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Rotation Direction: \(trick.rotationDirection)")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Divider()
                
                Text(trick.description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.bottom, 20)

                // 🔹 "Learn Trick"" Button
                Button(action: {
                    // Action folgt später
                }) {
                    Text("Learn Trick")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                }
            }
            .padding()
        }
        .background(Color(.systemBlue).opacity(0.2))
        .navigationTitle(trick.name)
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
