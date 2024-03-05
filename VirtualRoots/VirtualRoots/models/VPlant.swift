//
//  VPlant.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 04/03/24.
//

import Foundation

struct VPlantJson:Decodable {
    let id : Int
    let name : String
    let description: String
    let image: String
}

class VPlant : ObservableObject {
    let id : Int
    let name : String
    let description: String
    let image: String
    @Published var isChecked: Bool = false
    
    // Inicializador que toma una estructura VPlant (que se decodifica del JSON)
    init(from vPlant: VPlantJson) {
        self.id = vPlant.id
        self.name = vPlant.name
        self.description = vPlant.description
        self.image = vPlant.image
    }
}
