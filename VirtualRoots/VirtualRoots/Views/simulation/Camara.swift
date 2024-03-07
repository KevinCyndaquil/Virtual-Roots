//
//  Camara.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 06/03/24.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit

struct CamaraSimulation: View {
    @State private var isAddMode: Bool = true  // Estado para controlar si estamos en modo de agregar o mover
    @State private var deleteAll: Bool = false
    @State private var modelScale: CGFloat = 0.05 // Valor inicial del tamaño del modelo
    @State private var isLoading = true
    var body: some View {
        ZStack{

            ARViewContainer(isAddMode: $isAddMode, deleteAll: $deleteAll, modelScale: $modelScale, isLoading: $isLoading).edgesIgnoringSafeArea(.all)
                
                VStack{
                    // Coloca un Spacer primero para empujar todo hacia abajo
                    
                    Text("Bienvenido a la Realidad Aumentada")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                    
                    Button(action: {
                        // Cambia el modo entre agregar y mover
                        self.isAddMode.toggle()
                    }) {
                        Text(isAddMode ? "Cambiar a Mover" : "Cambiar a Agregar")
                            .foregroundColor(.blue)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    }
                    
                    // Puedes poner otro Spacer aquí si quieres que el botón de cambio y el texto estén más centrados
                    Spacer()
                    Slider(value: $modelScale, in: 0.01...0.1) // Ajusta el rango según sea necesario
                        .padding()
                    HStack{
                        Button(action: {
                            // Eliminar todos los modelos de la vista
                            self.deleteAll.toggle()
                        }) {
                            Text("Eliminar todos")
                                .foregroundColor(.red)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                        }.padding()
                     
                    }// Asegura que el botón "Eliminar todos" tenga algo de espacio en la parte inferior
                }
            
            
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var isAddMode: Bool  // Estado proveniente de ContentView
    @Binding var deleteAll: Bool
    @Binding var modelScale: CGFloat
    @Binding var isLoading: Bool
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        // Configuraciones de la sesión de AR
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config)
        
        // Añadir el reconocedor de toques
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        arView.addGestureRecognizer(tapGestureRecognizer)
        
//DispatchQueue.main.async {
            //       self.isLoading = false
            //   }
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        context.coordinator.isAddMode = isAddMode
        context.coordinator.deleteAll = deleteAll
        context.coordinator.modelScale = modelScale
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(arView: self, isAddMode: isAddMode, deleteAll: deleteAll, modelScale: modelScale)
    }

    class Coordinator: NSObject {
        var arViewContainer: ARViewContainer
        var isAddMode: Bool
        var deleteAll: Bool
        var modelScale: CGFloat
        var lastAnchor: AnchorEntity? // Referencia al último AnchorEntity añadido
        let plant: String = "grownCacaoTree.usdz"

        init(arView: ARViewContainer, isAddMode: Bool, deleteAll: Bool, modelScale: CGFloat) {
            self.arViewContainer = arView
            self.isAddMode = isAddMode
            self.deleteAll = deleteAll
            self.modelScale = modelScale
        }
        
        @objc func handleTap(sender: UITapGestureRecognizer) {
            guard let arView = sender.view as? ARView else { return }
            let touchLocation = sender.location(in: arView)
            
            let hitTestResults = arView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let firstResult = hitTestResults.first {
                if isAddMode {
                    // Modo añadir: crea y añade un nuevo anchor y modelo
                    let anchor = AnchorEntity(world: firstResult.worldTransform)
                    if let modelEntity = try? ModelEntity.loadModel(named: plant) {
                        modelEntity.scale = SIMD3<Float>(repeating: Float(modelScale))
                        anchor.addChild(modelEntity)
                        arView.scene.addAnchor(anchor)
                        // Guarda esta entidad de anclaje como la última añadida
                        lastAnchor = anchor
                    }
                } else {
                    // Modo mover: elimina el último modelo añadido
                    if let lastAnchor = lastAnchor {
                        arView.scene.removeAnchor(lastAnchor)
                    }
                    // Crea y añade un nuevo anchor y modelo
                    let newAnchor = AnchorEntity(world: firstResult.worldTransform)
                    if let newModelEntity = try? ModelEntity.loadModel(named: plant) {
                        newModelEntity.scale = SIMD3<Float>(x: 0.05, y: 0.05, z: 0.05)
                        newAnchor.addChild(newModelEntity)
                        arView.scene.addAnchor(newAnchor)
                        // Actualiza la referencia del último anchor añadido
                        self.lastAnchor = newAnchor
                    }
                }
                
                
            }
            if deleteAll {
                arView.scene.anchors.removeAll()
                deleteAll.toggle()
            }
        }
    }
}
