//
//  viewModelListPlants.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 05/03/24.
//

import Foundation

class PlantsListViewModel: ObservableObject {
    @Published var listPlants: [VPlant]
    @Published var isMaximum : Bool = false
    
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
    
    func checked(index: Int) {
            // Contar cuántas plantas están marcadas como checked
            let checkedCount = listPlants.filter { $0.isChecked }.count
        print("estas estas como verdaderas \(checkedCount)")
        print("el que tocaste estaba como  \(listPlants[index].isChecked)")
                if checkedCount < 6  {
                    listPlants[index].isChecked = true;
                    print("se puso \(listPlants[index].isChecked)")
                    listPlants = listPlants.map { $0 }
                    isMaximum = false
                }else{
                    isMaximum = true
                }
        }
    
    func getCheckedPlants() -> [VPlant] {
        return listPlants.filter { $0.isChecked }
    }
}
