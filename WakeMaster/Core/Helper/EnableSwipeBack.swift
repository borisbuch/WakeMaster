//
//  EnableSwipeBack.swift
//  WakeMaster
//
//  Created by Boris on 25.03.26.
//

import SwiftUI

struct EnableSwipeBack: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        
        DispatchQueue.main.async {
            if let nav = vc.navigationController {
                nav.interactivePopGestureRecognizer?.isEnabled = true
                nav.interactivePopGestureRecognizer?.delegate = nil
            }
        }
        
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
