//
//  model.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 01/03/24.
//

import Foundation




public struct MaxMin <T> {
    var max: T
    var min: T
}

public class VRModelPhase {
    var name: String
    var environment: MaxMin<VREnvironment>
    var phaseDuration: MaxMin<CGFloat>
    var phaseOccurred: CGFloat = 0.0
    
    init( name: String, environment: MaxMin<VREnvironment>, phaseDuration: MaxMin<CGFloat>) {
        self.name = name
        self.environment = environment
        self.phaseDuration = phaseDuration
    }
}

/**
 The abstract model that will be use to describe a plant
 */
public class VRModel: Hashable {
    var _id: Int
    var phases: [VRModelPhase] = []
    var name: String
    var currentPhase: VRModelPhase?
    var currentAge: CGFloat = 0.0
    var idealAge: CGFloat
    
    public init(_id: Int, name: String, idealAge: CGFloat) {
        self._id = _id
        self.name = name
        self.idealAge = idealAge
        self.phases = asignPhases()
    }
    
    fileprivate func asignPhases() -> [VRModelPhase] {
        return []
    }
    
    /**
     Obtains the consume of this model, otherwise, obtains the average between max and min VREnvironment in currentPhase attribute
     */
    public func consume() -> VREnvironment {
        guard let currentPhase = self.currentPhase else { return .zero }
        return (currentPhase.environment.max + currentPhase.environment.min) / 2
    }
    
    public static func == (lhs: VRModel, rhs: VRModel) -> Bool {
        return lhs._id == rhs._id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
}

public class Corn: VRModel {
    
    public init(_id: Int) {
        super.init(_id: _id, name: "CORN PLANT", idealAge: 6400000.0)
    }
    
    override fileprivate func asignPhases() -> [VRModelPhase] {
        return [
            VRModelPhase(name: "emergencia",
                         environment: MaxMin(max: VREnvironment(light: 400.0,
                                                                temperature: 24.0,
                                                                ground: VRGround(ph: 7, nitrogen: 2.1, phosphorus: 3.8, potassium: 0.6),
                                                                atmosphere: VRAtmosphere(humidity: 65.0, carbonDioxide: 1000.0)),
                                             min: VREnvironment(light: 200.0,
                                                                temperature: 18.0,
                                                                ground: VRGround(ph: 6, nitrogen: 2.1, phosphorus: 3.8, potassium: 0.6),
                                                                atmosphere: VRAtmosphere(humidity: 55.0, carbonDioxide: 415.0))),
                         phaseDuration: MaxMin(max: 1036800.0, min: 0.0)),
        ]
    }
}

