import SwiftUI


struct HomeView: View {
    var body: some View {
        NavigationStack{
            
            ScrollView {
                StickySection {
                    HStack {
                        VStack {
                            RingView()
                                .padding(8)
                            Spacer()
                        }
                        Spacer()
                        
                        VStack (alignment: .leading){
                            Spacer()
                            ForEach(Trick.ProgressionLevel.allCases, id: \.self) { pLevel in
                                HStack {
                                    Label(pLevel.rawValue, systemImage: pLevel.symbol)
                                        .foregroundStyle(pLevel.color)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    
                                }
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    
                    
                } header: {
                    HStack (spacing: 10) {
                        Text("Progress")
                        Spacer()
                        Image(systemName: "chart.bar.fill")
                        
                    }
                    .padding(.vertical, 0)
                } minimisedHeader: {
                    HStack (spacing: 10) {
                        
                        
                        Image(systemName: "chart.bar.fill")
                        
                        Text("Progress")
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 0)
                }
                .padding(.horizontal)
            
                

            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Dashboard")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar{
                //Toolbar Menu
                ToolbarItem(placement: .topBarTrailing) {
                    Button {

                               print("Button gedrückt")

                           } label: {

                               Image(systemName: "gearshape")

                           }
                    
                        }
                       
                    }
                }
            }
            
        }
        
        

        

// MARK: - Preview
#Preview {
    HomeView()
}
