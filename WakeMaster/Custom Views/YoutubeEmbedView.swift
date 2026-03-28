//
//  YoutubeEmbedView.swift
//  WakeMaster
//
//  Created by Boris on 25.03.26.
//

import SwiftUI
import WebKit
//a SwiftUI wrapper for WKWebKit to embed YT videos
struct YoutubeEmbedView: UIViewRepresentable {
    let trick: Trick //yt video Id, aber nicht die ganze URL
    
    var videoID: String {
        if trick.videoID == ""{
            return "rn6R4ncd2OU?si=u70Wi84cydHEGJlA"
        }else {
            return trick.videoID
        }

    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        
        return webView
    }
        
        
        //load the youtube video into the webview
        func updateUIView(_ webView: WKWebView, context: Context) {
            var html: String = ""
            let cleanID = sanitizeID(videoID)
            
            html = makeEmbedHTML(
                src: "https://www.youtube-nocookie.com/embed/\(cleanID)?playsinline=1&modestbranding=1&rel=0&enablejsapi=1&origin=https://www.youtube-nocookie.com"
            )
            webView.loadHTMLString(html, baseURL: URL(string: "https://www.youtube-nocookie.com"))
        }
    


    // MARK: - Helper: Clean "VIDEO_ID?si=xyz"
    private func sanitizeID(_ raw: String) -> String {
        raw.components(separatedBy: ["?", "&"]).first ?? raw
    }

    // MARK: - Helper: Build Responsive HTML
    private func makeEmbedHTML(src: String) -> String {
        """
        <html>
        <head>
            <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
        </head>
        <body style="margin:0; padding:0; background:black;">
            <iframe
                width="100%"
                height="100%"
                src="\(src)"
                frameborder="0"
                allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen>
            </iframe>
        </body>
        </html>
        """
    }
}
