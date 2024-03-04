//
//  ContentView.swift
//  VirtualRoots
//
//  Created by KevinCyndaquil, Maguchi & Jackinjaxx on 01/03/24.
//

import SwiftUI
import UIKit
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().ignoresSafeArea(.all)
    }
}

struct ARViewContainer: UIViewControllerRepresentable {
    typealias UIViewControllerType = UISimulationController
    
    func makeUIViewController(context: Context) -> UISimulationController {
        let controller = UISimulationController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UISimulationController, context: Context) {
    }
}

#Preview {
    ContentView()
}
