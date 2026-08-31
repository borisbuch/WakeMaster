import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            
            ScrollView {
                StickySection {
                    VStack {
                        RingView()
                            .padding()
                        Spacer()
                    }
                    .navigationTitle("Dashboard")
                    .toolbarTitleDisplayMode(.inlineLarge)
                    
                } header: {
                    HStack (spacing: 10) {
                        Text("Progress")
                        Spacer()
                        Image(systemName: "chart.bar.fill")
                        
                    }
                    .padding(.vertical, 10)
                } minimisedHeader: {
                    HStack (spacing: 10) {
                        
                        
                        Image(systemName: "chart.bar.fill")
                        
                        Text("Progress")
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 10)
                }
                .padding()
            }

            
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
