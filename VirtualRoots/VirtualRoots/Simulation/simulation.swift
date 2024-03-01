//
//  simulation.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 01/03/24.
//

import Foundation

public struct SimulationTimeControl {
    var start: CGFloat
    var end: CGFloat
    var current: CGFloat
    var framesPer: CGFloat
}

public class VRController {
    var environments: [VREnvironment] = []
    var timeControl: SimulationTimeControl
    var nodes: [VRModel]
    var ground: VRGround.GType
    
    public init(environments: [VREnvironment], timeControl: SimulationTimeControl, nodes: [VRModel], ground: VRGround.GType) {
        self.environments = environments
        self.timeControl = timeControl
        self.nodes = nodes
        self.ground = ground
    }
    
    
}
