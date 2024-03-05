//
//  SimulacionHome.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 04/03/24.
//

import Foundation
import SwiftUI

struct ListPlantsUI: View {
    private var virtualBold = "PlusJakartaSans-Regular_Bold"
    private var virtualLight = "PlusJakartaSans-Regular_Light"
    @StateObject var plantsViewModel = PlantsViewModel()
    @Binding var showing: Bool
    
    private func loadBonesData() {
        // Tu código para cargar los datos JSON...
        if let path = Bundle.main.path(forResource: "plants", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let loadedPlants = try JSONDecoder().decode([VPlantJson].self, from: data)
                // Convertir los VPlant decodificados a VPlantModel
                let plantModels = loadedPlants.map { VPlant(from: $0) }
                
                
            } catch {
                // Si hay un error, imprimirlo en la consola
                print("Error al cargar el archivo JSON: \(error)")
            }
        } else {
            print("No se pudo encontrar el archivo JSON en el bundle.")
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {
                        Image("flechasalir")
                            .frame(width: 58.3073, height: 50)
                        
                    }
                    .padding(10)
                    HStack(alignment: .center, spacing: 10) {  }
                        .padding(.horizontal, 0)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, minHeight: 43, maxHeight: 43, alignment: .center)
                    HStack(alignment: .center, spacing: 10) {
                        Image("searchMin")
                            .frame(width: 50, height: 50.00977)
                        
                    }
                    .padding(10)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                HStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Plants")
                            .font(
                                Font.custom(virtualBold, size: 36)
                            )
                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04))
                        Text("Select the plants to add")
                            .font(
                                Font.custom(virtualLight, size: 24)
                            )
                            .foregroundColor(Color(red: 0.1, green: 0.16, blue: 0.04).opacity(0.5))
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                VStack(alignment: .center, spacing: 10) { }
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 34)
            .frame(maxWidth: .infinity, minHeight: 1036, maxHeight: 1036, alignment: .topLeading)
            NavBar()
        }
        .padding(0)
        .frame(width: 834, alignment: .center)
        .background(Color(red: 0.96, green: 0.98, blue: 0.92))
    }
    
    
}



