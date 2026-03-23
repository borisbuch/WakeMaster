//
//  WakeMasterApp.swift
//  WakeMaster
//
//  Created by Mischa Saleh on 05.09.25.
//

import SwiftUI
import SwiftData

@main
struct WakeMasterApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: TrickProgress.self)
    }
}

#Preview {
    HomeView()
}
