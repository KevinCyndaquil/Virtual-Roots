//
//  SimulacionHome.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 04/03/24.
//

import Foundation
import SwiftUI

struct ListPlantsUI: View {
    @StateObject var plantsViewModel = PlantsViewModel()
    @Binding var showing:Bool
    
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
        VStack(alignment: .center, spacing: 0) { }
        .padding(0)
        .frame(width: 834, alignment: .center)
        .background(Color(red: 0.96, green: 0.98, blue: 0.92))
        .overlay(
          Rectangle()
            .inset(by: 0.5)
            .stroke(.black, lineWidth: 1)
        )
    }
    
   
}



