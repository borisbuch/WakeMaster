//
//  Tricks.swift
//  WakeMaster
//
//  Created by Boris on 21.03.26.
//

import SwiftUI

// Returns a concrete Color for a given Trick.
// Adjust the switch once Trick's cases are known.
/// Returns a cocrete Color for a given Trick, based on the difficulty.
/// - Parameter trick: given Trick
/// - Returns: color for the difficulty of the trick
func getGridItemColour(trick: Trick) -> Color {
    // Placeholder mapping: update with real logic when Trick is defined.
    switch  trick.progressionLevel{
    case "Beginner":
        return Color.mint
    case "Advanced":
        return Color.cyan
    case "Pro":
        return Color.indigo
    case "Expert":
        return Color.purple
    default:
        return Color.black
    }
    
}

/// Returns a cocrete Integer for a given Trick, based on the difficulty.
/// - Parameter trick: given Trick
/// - Returns: integer for dificulty
func getDifficultyIntegerColour(trick: Trick) -> Int {
    // Placeholder mapping: update with real logic when Trick is defined.
    switch  trick.progressionLevel{
    case "Beginner":
        return 0
    case "Advanced":
        return 1
    case "Pro":
        return 2
    case "Expert":
        return 3
    default:
        return 4
    }
    
}
