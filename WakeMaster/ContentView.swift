//
//  ContentView.swift
//  WakeMaster
//
//  Created by Mischa Saleh on 05.09.25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1

    var body: some View {
        
        
        ZStack {
            // Display the selected tab's view
            Group {
                switch selectedTab {
                                case 0:
                                    NavigationStack { HomeView() }
                                case 1:
                                    NavigationStack { TricksView() }
                                case 2:
                                    NavigationStack { FriendsView() }
                                case 3:
                                    NavigationStack { SearchView() }
                                default:
                                    NavigationStack { HomeView() }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            
            // Floating tab bar
                        VStack {
                            Spacer()
                            HStack(spacing: 40) {
                                TabBarButton(icon: "house.fill", title: "Home", index: 0, selectedTab: $selectedTab)
                                TabBarButton(icon: "figure.snowboarding", title: "Tricks", index: 1, selectedTab: $selectedTab)
                                TabBarButton(icon: "person.2.fill", title: "Friends", index: 2, selectedTab: $selectedTab)
                                TabBarButton(icon: "magnifyingglass", title: "", index: 3, selectedTab: $selectedTab)
                            }
                            .padding(.horizontal, 25)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                        }
                    }
                }
            }

            #Preview {
                ContentView()
            }
