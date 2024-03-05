//
//  viewModelListPlants.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 05/03/24.
//

import Foundation

class PlantsListViewModel: ObservableObject {
    @Published var listPlants: [VPlant]
    let maxSelections = 6
    
    init() {
        if let path = Bundle.main.path(forResource: "plants", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let loadedPlants = try JSONDecoder().decode([VPlantJson].self, from: data)
                // Convertir los VPlant decodificados a VPlantModel
                let plants = loadedPlants.map { VPlant(from: $0) }
                
                self.listPlants = plants
            } catch {
                // Si hay un error, imprimirlo en la consola
                print("Error al cargar el archivo JSON: \(error)")
                self.listPlants = []
            }
        } else {
            print("No se pudo encontrar el archivo JSON en el bundle.")
            self.listPlants = []
        }
    }
    
    func toggleIsChecked(for plantId: Int) {
        // Contar cuántas plantas ya están seleccionadas
        let selectedCount = listPlants.filter { $0.isChecked }.count
        
        // Encontrar índice de la planta que se quiere cambiar
        if let index = listPlants.firstIndex(where: { $0.id == plantId }) {
            if selectedCount < maxSelections {
                listPlants[index].isChecked.toggle()
            }
            // Opcional: Agregar lógica aquí si quieres informar al usuario que no se puede seleccionar más elementos
        }
    }
    
}
