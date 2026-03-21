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
        
    //TabBar minimize on Scroll ist nur in iOS 26+ verfügbar
        
        if #available(iOS 26.0, *) {
            TabBar()
                .tabBarMinimizeBehavior(.onScrollDown)
        } else {
            // Fallback on earlier versions
            TabBar()
        }
            }
    
    
}
                


            #Preview {
                MainView()
            }
