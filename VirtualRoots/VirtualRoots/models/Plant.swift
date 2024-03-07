//
//  VPlant.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 04/03/24.
//

import Foundation


struct PlantStage: Decodable {
    let id : Int
    let tiempo : String
    let imagen : String
    let water :  String
    let plaga : String
    let imagen_plaga : String
}

struct VPlantJson:Decodable {
    let id : Int
    let name : String
    let scientific_name : String
    let temperature : String
    let temperature_img : String
    let description: String
    let image: String
    let etapas : [PlantStage]
    let ground : VGround
}

class Plant : ObservableObject {
    let id : Int
    let name : String
    let scientific_name : String
    let temperature : String
    let temperature_img : String
    let description: String
    let image: String
    let etapas : [PlantStage]
    let ground : VGround
    @Published var isChecked: Bool = false
    
    // Inicializador que toma una estructura VPlant (que se decodifica del JSON)
    init(from vPlant: VPlantJson) {
        self.id = vPlant.id
        self.name = vPlant.name
        self.description = vPlant.description
        self.image = vPlant.image
        self.scientific_name = vPlant.scientific_name
        self.temperature = vPlant.temperature
        self.temperature_img = vPlant.temperature_img
        self.etapas = vPlant.etapas
        self.ground = vPlant.ground
    }
    

    
}
