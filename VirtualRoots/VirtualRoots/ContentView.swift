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
    typealias UIViewControllerType = ARViewController
    
    class Coordinator {
        var parent: ARViewContainer
        var controller: UIViewController?
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> ARViewController {
        let controller = ARViewController()
        context.coordinator.controller = controller
        
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {
    }
}

#Preview {
    ContentView()
}

class ARViewController: UIViewController {
    var simulationTimer: Timer?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        simulationTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(thread), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.frame = UIScreen.main.bounds
        
        let arView = ARView(frame: view.frame)
        arView.backgroundColor = .clear
        
        // Create a cube model
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        let model = ModelEntity(mesh: mesh, materials: [material])
        model.transform.translation.y = 0.05

        // Create horizontal plane anchor for the content
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        anchor.children.append(model)

        // Add the horizontal plane anchor to the scene
        arView.scene.anchors.append(anchor)
        
        label.frame = CGRect(origin: view.center, size: CGSize(width: 100, height: 30))
        label.text = "HELLO"
        label.textColor = .white
        arView.addSubview(label)
        
        view.addSubview(arView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        simulationTimer?.invalidate()
        simulationTimer = nil
    }
    
    @objc fileprivate func thread() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.label.text = self.label.text == "WORLD" ? "HELLO" : "WORLD"
            }
        }
    }
    
    let label = UILabel()
}
