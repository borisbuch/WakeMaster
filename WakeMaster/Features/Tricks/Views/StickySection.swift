//
//  StickySection.swift
//  WakeMaster
//
//  Created by Boris on 31.08.26.
//

import SwiftUI

struct StickySection<Content: View, Header: View, MinimisedHeader: View>:
    View {
    var config: Config = .init()
    var spacing: CGFloat = 10
    @ViewBuilder var content: Content
    @ViewBuilder var header: Header
    @ViewBuilder var minimisedHeader: MinimisedHeader
    //View Properties
    @State private var headerSize: CGSize = .zero
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            header
                .visualEffect { content, proxy in
                    let rect = proxy.frame(in: .named("SECTION"))
                    let minY = max(rect.minY - config.sectionPadding, 0)
                    let progress = max(min(minY / config.headerFadeDistance,  1), 0)
                    return content
                        .opacity(1 - progress)
                }
                .background{
                    minimisedHeader
                        .frame(maxHeight: .infinity)
                        .offset(y: config.minimisedHeaderOffset / 2)
                        .visualEffect { content, proxy in
                            let rect = proxy.frame(in: .named("SECTION"))
                            let minY = max(rect.minY - config.sectionPadding - config.headerFadeDistance, 0)
                            let progress = max(min(minY / config.headerFadeDistance,  1), 0)
                            return content
                                .opacity(progress)
                        }
                }
                .padding([.horizontal, .top], config.sectionPadding)
                .onGeometryChange(for: CGSize.self) {
                    $0.size
                } action: { newValue in
                    headerSize = newValue
                }

            content
                .padding([.horizontal, .top], config.sectionPadding)
                .visualEffect { content, proxy in
                    let rect = proxy.frame(in: .named("SECTION"))
                    let scrollMinY = proxy.frame(in: .scrollView(axis: .vertical)).minY
                    let minY = max(rect.minY - scrollMinY, 0)
                    return content
                        .offset(y: -minY)
                }
                .clipped()
        }
        .background{
            GeometryReader { proxy in
                let rect = proxy.frame(in: .named("SECTION"))
                let viewHeight = proxy.size.height
                let headerHeight = headerSize.height + config.sectionPadding + config.minimisedHeaderOffset
                let bottomPadding = min(max(rect.minY, 0), viewHeight - headerHeight )
                Group {
                    if config.isGlassBackground {
                        Rectangle()
                            .fill(.clear)
                            .glassEffect(.regular, in: .rect(cornerRadius: config.cornerRadius))
                    } else {
                        RoundedRectangle(cornerRadius: config.cornerRadius)
                            .fill(config.background)
                    }
                }
                .padding(.bottom, bottomPadding)
            }
            
        }
        .mask{
            GeometryReader { proxy in
                let rect = proxy.frame(in: .named("SECTION"))
                let viewHeight = proxy.size.height
                let headerHeight = headerSize.height + config.sectionPadding + config.minimisedHeaderOffset
                let bottomPadding = min(max(rect.minY, 0), viewHeight - headerHeight )
                
                RoundedRectangle(cornerRadius: config.cornerRadius)
                    .padding(.bottom, bottomPadding)
            }
        }
        .compositingGroup()
        .visualEffect{[headerSize] content, proxy in
            let rect = proxy.frame(in: .scrollView(axis: .vertical))
            let minY = rect.minY
            let headerHeight = headerSize.height + config.sectionPadding + config.minimisedHeaderOffset
            let cutoffHeight = proxy.size.height - headerHeight
            let distance = abs(min(cutoffHeight + minY, 0))
            let progress = max(min(distance / config.fadeDistance, 1), 0)
            let scale = 1 - (progress * config.fadeScale)
            let opacity = 1 - progress
            
            return content
                .scaleEffect(scale, anchor: .top)
                .opacity(opacity)
                .offset(y: minY < 0 ? -minY : 0)
        }
        .coordinateSpace(.named("SECTION"))
    }
    struct Config {
        var sectionPadding: CGFloat = 16
        var cornerRadius: CGFloat = 20
        var background: AnyShapeStyle = .init(.fill.tertiary)
        var isGlassBackground: Bool = false
        
        var minimisedHeaderOffset: CGFloat = -10
        var headerFadeDistance: CGFloat = 15
        var fadeDistance: CGFloat = 45
        var fadeScale: CGFloat = 0.5
    }
}

#Preview {
    MainView()
}
