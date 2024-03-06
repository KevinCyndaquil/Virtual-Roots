//
//  Plants.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 06/03/24.
//

import Foundation

class Corn: VPlant {
    static let SEED: Phase = Phase(name: "seed",
                                   waterConsume: Consume(consume: VWater(quantity: 10), needed: VWater(quantity: 8)),
                                   lightConsume: Consume(consume: VLight(quantity: 200, temperature: VTemperature(quantity: 20)), 
                                                         needed: VLight(quantity: 150, temperature: VTemperature(quantity: 20))),
                                   nutrientsConsume: Consume(consume: [.K, .N], needed: [.K, .N]),
                                   maxAge: 3,
                                   modelName: "")
    
    static let BLOOM: Phase = Phase(name: "bloom",
                                   waterConsume: Consume(consume: VWater(quantity: 10), needed: VWater(quantity: 8)),
                                   lightConsume: Consume(consume: VLight(quantity: 200, temperature: VTemperature(quantity: 20)),
                                                         needed: VLight(quantity: 150, temperature: VTemperature(quantity: 20))),
                                   nutrientsConsume: Consume(consume: [.K, .N], needed: [.K, .N]),
                                   maxAge: 80,
                                   modelName: "")
    
    static let MATURATION: Phase = Phase(name: "maturation",
                                   waterConsume: Consume(consume: VWater(quantity: 10), needed: VWater(quantity: 8)),
                                   lightConsume: Consume(consume: VLight(quantity: 200, temperature: VTemperature(quantity: 20)),
                                                         needed: VLight(quantity: 150, temperature: VTemperature(quantity: 20))),
                                   nutrientsConsume: Consume(consume: [.K, .N], needed: [.K, .N]),
                                   maxAge: 160,
                                   modelName: "")
    
    static let HARVEST: Phase = Phase(name: "harvest",
                                   waterConsume: Consume(consume: VWater(quantity: 10), needed: VWater(quantity: 8)),
                                   lightConsume: Consume(consume: VLight(quantity: 200, temperature: VTemperature(quantity: 20)),
                                                         needed: VLight(quantity: 150, temperature: VTemperature(quantity: 20))),
                                   nutrientsConsume: Consume(consume: [.K, .N], needed: [.K, .N]),
                                   maxAge: 210,
                                   modelName: "")
        
    override init(name: String, timeOfSimulation: CGFloat) {
        super.init(name: name, timeOfSimulation: timeOfSimulation)
        
        add(phase: Corn.SEED)
        add(phase: Corn.BLOOM)
        add(phase: Corn.MATURATION)
        add(phase: Corn.HARVEST)
        
        act(action: VRAction.repeat(key: "plant-growing", duration: timeOfSimulation) {
            let age = self.age
            
            if self.currentPhase?.maxAge ?? 0 >= age { return }
            
            print("\(name) has changed!!")
            self.currentPhase = self.phases.reduce(nil, { age <= $1.maxAge ? $1 : $0 })
        })
    }
}
