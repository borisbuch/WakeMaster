//
//  ContentView.swift
//  WakeMaster
//
//  Created by Mischa Saleh on 05.09.25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        
        TabBar()
            .tabBarMinimizeBehavior(.onScrollDown)
        
        
    }
    
}
                


            #Preview {
                MainView()
            }
