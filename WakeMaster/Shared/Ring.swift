//
//  Ring.swift
//  WakeMaster
//
//  Created by Boris on 29.03.26.
//

import SwiftUI

//MARK: Progress Ring Model and Sample Data

struct Ring : Identifiable {
    var id = UUID().uuidString
    var progress: CGFloat
    var value: String
    var keyIcon: String
    var keyColor: Color
    var isText: Bool = false
}

var rings: [Ring] = [
    Ring(progress: 0, value: "Beginner", keyIcon: Trick.ProgressionLevel.expert.symbol, keyColor: Trick.ProgressionLevel.expert.color),
    Ring(progress: 20, value: "Beginner", keyIcon: Trick.ProgressionLevel.pro.symbol, keyColor: Trick.ProgressionLevel.pro.color),
    Ring(progress: 50, value: "Beginner", keyIcon: Trick.ProgressionLevel.advanced.symbol, keyColor: Trick.ProgressionLevel.advanced.color),

    Ring(progress: 99, value: "Beginner", keyIcon: Trick.ProgressionLevel.beginner.symbol, keyColor: Trick.ProgressionLevel.beginner.color),
]

