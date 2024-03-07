//
//  viewModelListPlants.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 05/03/24.
//

import Foundation

class PlantsListViewModel: ObservableObject {
    @Published var listPlants: [Plant]
    let list : [Plant]
    @Published var isMaximum : Bool = false
    
    init() {
        if let path = Bundle.main.path(forResource: "plants_model", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let loadedPlants = try JSONDecoder().decode([VPlantJson].self, from: data)
                // Convertir los VPlant decodificados a VPlantModel
                let plants = loadedPlants.map { Plant(from: $0) }
                
                
                
                self.listPlants = plants
                self.list = plants
            } catch {
                // Si hay un error, imprimirlo en la consola
                print("Error al cargar el archivo JSON: \(error)")
                self.listPlants = []
                self.list = []
            }
        } else {
            print("No se pudo encontrar el archivo JSON en el bundle.")
            self.listPlants = []
            self.list = []
        }
    }
    
    func updatePlantCheckStatus(from updatedPlants: [Plant]) {
            for updatedPlant in updatedPlants {
                if let index = listPlants.firstIndex(where: { $0.id == updatedPlant.id }) {
                    listPlants[index].isChecked = updatedPlant.isChecked
                    print("Plantas marcadas como checked:")
                       for plant in updatedPlants {
                           print("ID: \(plant.id), Checked: \(plant.isChecked)")
                       }
                    listPlants = listPlants.map{$0}
                }
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
    
    func getCheckedPlants() -> [Plant] {
        return listPlants.filter { $0.isChecked }
    }
    
    func filterName(name : String){
        print(name)
        if(name.isEmpty) {
            listPlants = list;
            return
        }
        
        listPlants = list.filter{$0.name.lowercased().contains(name.lowercased())}
    }
}
