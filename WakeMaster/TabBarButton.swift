//
//  TabBarButton.swift
//  WakeMaster
//
//  Created by Mischa Saleh on 05.09.25.
//

import SwiftUI

struct TabBarButton: View {
    let icon: String
    let title: String
    let index: Int
    @Binding var selectedTab: Int

    var body: some View {
        Button(action: { selectedTab = index }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                if !title.isEmpty {
                    Text(title)
                        .font(.caption2)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .foregroundColor(selectedTab == index ? .blue : .gray)
            .background(
                ZStack {
                    if selectedTab == index {
                        RoundedRectangle(cornerRadius: 45) // fixed corner radius
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 60) // keep height fixed
                                        .frame(minWidth: 100) // make it wider
                    }
                }
            )
        }
        .animation(.spring(), value: selectedTab)
    }
}

