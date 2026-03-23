//
//  Tabbar.swift
//  WakeMaster
//
//  Created by Boris on 21.03.26.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView{
            Tab.init("Home", systemImage: "house.fill") {
                HomeView()
            }
            Tab.init("Tricks", systemImage: "figure.snowboarding") {
                GridTrickView()
            }
            Tab.init("Home", systemImage: "person.2.fill") {
                FriendsView()
            }
        }
        
    }
}
