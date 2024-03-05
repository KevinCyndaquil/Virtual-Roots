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
        HomeUI()
    }
}


#Preview {
    ContentView()
}

class ARViewController: UIViewController {
    var simulation: VRController = .init()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        simulation.timeControl = SimulationTimeControl(end: 10000.0)
        simulation.nodes.append(contentsOf: [Corn(_id: 0)])
        simulation.updateView = {
            self.label.text = self.label.text == "HELLO" ? "WORLD" : "HELLO"
        }
        simulation.environments.append(VREnvironment(light: 200, temperature: 30, ground: VRGround(ph: 7, nitrogen: 300, phosphorus: 600, potassium: 300), atmosphere: VRAtmosphere(humidity: 70, carbonDioxide: 800)))
        simulation.start()
        print(simulation.status)
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
        simulation.finish()
    }
    
    let label = UILabel()
}
