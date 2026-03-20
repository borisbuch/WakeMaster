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
    let progressionLevel: String
    let category: String
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

        guard components.count >= 7 else { return nil }
        self.name = components[1]
        self.description = components[2]
        self.progressionLevel = components[3]
        self.category = components[4]
        self.edgeType = components[5]
        self.rotationDirection = components[6]
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
    var tricksByLevel: [String: [Trick]] {
        Dictionary(grouping: tricks, by: { $0.progressionLevel })
    }

    var sortedLevels: [String] {
        ["Beginner", "Advanced", "Pro", "Expert"].filter { tricksByLevel.keys.contains($0) }
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
                                Text(level)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.primary)
                            }
                            .padding(.leading, 5)

                            // Tricks für diese Stufe
                            ForEach(tricksByLevel[level]!) { trick in
                                NavigationLink(destination: TrickDetailView(trick: trick)) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(trick.name)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            Text(trick.category)
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
                Text("Category: \(trick.category)")
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
func iconName(for level: String) -> String {
    switch level {
    case "Beginner": return "tortoise.fill"
    case "Advanced": return "hare.fill"
    case "Pro": return "bolt.fill"
    case "Expert": return "crown.fill"
    default: return "star.fill"
    }
}

func color(for level: String) -> Color {
    switch level {
    case "Beginner": return .green
    case "Advanced": return .orange
    case "Pro": return .red
    case "Expert": return .purple
    default: return .accentColor
    }
}

// MARK: - Preview
#Preview {
    TricksView()
}
