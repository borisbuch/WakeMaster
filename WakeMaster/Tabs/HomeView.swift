import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Nichts weiter hier
                Spacer()
            }
            .navigationTitle("Home")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
