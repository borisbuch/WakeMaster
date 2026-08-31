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
                        .visualEffect { content, proxy in
                            let rect = proxy.frame(in: .named("SECTION"))
                            let minY = max(rect.minY - config.sectionPadding - config.headerFadeDistance, 0)
                            let progress = max(min(minY / config.headerFadeDistance,  1), 0)
                            return content
                                .opacity(progress)
                        }
                }
                .padding([.horizontal, .top], config.sectionPadding)
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
            }
            
        }
        .mask{
            RoundedRectangle(cornerRadius: config.cornerRadius)
        }
        .compositingGroup()
        .visualEffect{content, proxy in
            let rect = proxy.frame(in: .scrollView(axis: .vertical))
            let minY = rect.minY
            
            return content
                .offset(y: minY < 0 ? -minY : 0)
        }
        .coordinateSpace(.named("SECTION"))
    }
    struct Config {
        var sectionPadding: CGFloat = 16
        var cornerRadius: CGFloat = 20
        var background: AnyShapeStyle = .init(.fill.tertiary)
        var isGlassBackground: Bool = true
        
        var headerFadeDistance: CGFloat = 15
        var fadeDistance: CGFloat = 45
    }
}

#Preview {
    MainView()
}
