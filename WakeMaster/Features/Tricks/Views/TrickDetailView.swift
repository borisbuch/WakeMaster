//
//  TrickDetailView.swift
//  WakeMaster
//
//  Created by Boris on 25.03.26.
//


import SwiftUI
import SwiftData

/// Shows the a detailed view of the passed trick and shows the suiting video on top
struct TrickDetailView: View {
    /// the tricks Details are shown in the DetailView
    let trick: Trick
    /// dismiss is used to get Back to the previous page
    @Environment(\.dismiss) private var dismiss
    
    @Query private var trickProgress: [TrickProgress]
    
    
    init(trick: Trick) {
        self.trick = trick
        // Configure the SwiftData query with a predicate that compares TrickProgress.trickID to this trick's id
        let id = trick.id
        self._trickProgress = Query(filter: #Predicate<TrickProgress> { progress in
            progress.trickID == id
        })
    }
    
    var body: some View {
        VStack {
            
            //Embedded Youtube View
            YoutubeEmbedView(trick: trick)
                .frame(height: trick.videoID.isEmpty ? 0 : 250)
                //.clipShape(RoundedRectangle(cornerRadius: 30))
            //Bottom Trick-Detail Sheet
            NavigationStack {
                
                //ToolBar with Backbutton and Title
                ZStack {
                    HStack  {

                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .contentTransition(.symbolEffect)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                        .glassEffect()
                        .padding([.leading, .top], 18)
                        Spacer()
                        
                    }
                    Text(trick.name)
                        .font(.title.bold())
                        .padding(.top, 18)

                }
                
                // Scrollable trick details and description
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        
                        Text("Category: \(trick.category.rawValue)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("Edge Type: \(trick.edgeType)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("Rotation Direction: \(trick.rotationDirection)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Divider()
                        
                        Text(trick.description)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.bottom, 20)
                        
                        Divider()
                        
                    }
                    .padding()
                    
                    Spacer()
                }
                
            }
            // Gradient colour of the bottom Sheet
            .background(RoundedRectangle(cornerRadius: 40).fill(
                LinearGradient(
                        colors: [
                            trick.progressionLevel.color.opacity(0.9),
                            Color(.systemBackground)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
            ))
            .ignoresSafeArea()
            
        }
        .background(.black)
        //removes the back button on top and removes swipe gesture to get to the previous page
        .navigationBarBackButtonHidden(true)
        //reenables the swipe gesture
        .background(EnableSwipeBack())

    }
        
}

#Preview {
    let trick: Trick = loadTricksFromCSV()[7] //Sample Data for the preview
    TrickDetailView(trick: trick)
}
