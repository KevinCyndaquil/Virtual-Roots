//
//  simulation.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 01/03/24.
//

import Foundation

public class SimulationTimeControl {
    var start: CGFloat
    var end: CGFloat? = nil
    var current: CGFloat
    var framesPer: CGFloat
    
    public init(start: CGFloat = 0.0, end: CGFloat? = nil, current: CGFloat = 0.0, framesPer: CGFloat = 1.0) {
        self.start = start
        self.end = end
        self.current = current
        self.framesPer = framesPer
    }
    
    public func next() {
        current = current + framesPer
    }
}

public class VRController {
    var initEnvironment: VREnvironment = .zero
    var environments: [VREnvironment] = []
    var timeControl: SimulationTimeControl = .init()
    var nodes: [VRModel] = []
    
    var groundRecuperation: VRGround = .zero
    var ground: VRGround.GType?
    
    var atmosphereRecuperation: VRAtmosphere = .zero
    /**
     It is the water irrigated to the plant, not rain. (Mililiters per day)
     */
    var waterIrrigated: CGFloat = 0.0
    
    var repeater: Timer?
    var status: Status = .WAITING
    
    var updateView: () -> Void
    
    public enum Status {
        case ACTION
        case ENDED
        case STOPPED
        case WAITING
    }
    
    public init(updater: @escaping () -> Void = {}) {
        self.updateView = updater
    }
    
    public init(initEnvironment: VREnvironment, timeControl: SimulationTimeControl, nodes: [VRModel] = [], groundRecuperation: VRGround, ground: VRGround.GType, atmosphereRecuperation: VRAtmosphere, waterIrrigated: CGFloat, updater: @escaping () -> Void = {}) {
        self.initEnvironment = initEnvironment
        self.environments.append(self.initEnvironment)
        self.timeControl = timeControl
        self.nodes = nodes
        
        self.groundRecuperation = groundRecuperation
        self.ground = ground
        
        self.atmosphereRecuperation = atmosphereRecuperation
        self.waterIrrigated = waterIrrigated
        
        self.updateView = updater
    }
    
    public func start() {
        repeater = Timer(timeInterval: 0.5, target: self, selector: #selector(simulate), userInfo: nil, repeats: true)
        status = .ACTION
    }
    
    public func finish() {
        if (repeater == nil) { return }
        
        repeater?.invalidate()
        repeater = nil
        status = .ENDED
    }
    
    @objc fileprivate func simulate() {
        DispatchQueue.global(qos: .background).async {
            print("ACTION")
            
            guard let currentEnviroment = self.environments.last else {
                self.status = .WAITING
                return
            }
            
            /*if self.timeControl.end != nil {
                if self.timeControl.end! <= self.timeControl.current {
                    self.finish()
                    return
                }
            }*/
                
            let newEnvironment: VREnvironment = self.nodes.map {$0.consume()}
                .map {
                    let light: CGFloat = $0.light * self.timeControl.framesPer
                    let temperature: CGFloat = $0.temperature
                    let ground: VRGround = $0.ground * self.timeControl.framesPer - self.groundRecuperation
                    let atmosphere: VRAtmosphere = $0.atmosphere * self.timeControl.framesPer - self.atmosphereRecuperation
                    
                    return VREnvironment(
                        light: light,
                        temperature: temperature,
                        ground: ground,
                        atmosphere: atmosphere)
                }
                .reduce(currentEnviroment, -)
            newEnvironment.print()
            
            self.timeControl.next()
            
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
}