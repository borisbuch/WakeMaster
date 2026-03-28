//
//  TrickProgress.swift
//  WakeMaster
//
//  Created by Boris on 23.03.26.
//

import SwiftData
import SwiftUI

@Model
final class TrickProgress {
    var trickID: Int
    var status: Status
    
    init(
        trickID: Int,
        status: Status = .notLanded
    ) {
        self.trickID = trickID
        self.status = status
    }
}

enum Status: String, Codable, CaseIterable, Comparable, Hashable, MyEnumProtocol{
    case flagged = "Flagged"
    case landed = "Landed"
    case notLanded = "Not Landed"
     
    var color: Color {
        switch self {
        case .notLanded: return .gray
        case .flagged: return .red
        case .landed: return .green
        }
    }
    var symbol: String {
        switch self{
        case .notLanded: return "plus"
        case .flagged: return "flag"
        case .landed: return "checkmark"
        }
    }
    var next: Status {
            switch self {
            case .notLanded: return .flagged
            case .flagged: return .landed
            case .landed: return .notLanded
            }
        }
    var sort0rder: Int {
        switch self {
        case .flagged: return 0
        case .landed: return 1
        case .notLanded: return 2
        }
    }
    
    static func < (lhs: Status, rhs:Status) -> Bool {
        lhs.sort0rder < rhs.sort0rder
    }
    
}


