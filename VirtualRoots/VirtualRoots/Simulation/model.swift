//
//  model.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 01/03/24.
//

import Foundation


class VRAction {
    let key: String
    let duration: CGFloat
    var isLoopeable: Bool
    var isActing: Bool = false
    fileprivate let action: () -> Void
    var finished: Bool = false
    
    init(key: String = "", duration: CGFloat = 1.0, _ action: @escaping () -> Void) {
        self.key = key
        self.action = action
        self.isLoopeable = false
        self.duration = duration
    }
    
    init(key: String = "", duration: CGFloat = 1.0, isLoopeable: Bool, _ action: @escaping () -> Void) {
        self.key = key
        self.action = action
        self.isLoopeable = isLoopeable
        self.duration = duration
    }
    
    public func run() {
        action()
        
        if isLoopeable == true { return }
        finished = true
    }
    
    public static func run(key: String = "", duration: CGFloat = 1.0, _ action: @escaping () -> Void) -> VRAction {
        return VRAction(key: key, duration: duration, action)
    }
    
    public static func `repeat`(key: String = "", duration: CGFloat = 1.0, _ actionRepeat: @escaping () -> Void) -> VRAction {
        return VRAction(key: key, duration: duration, isLoopeable: true, actionRepeat)
    }
}

class VRActuable {
    var actions: [VRAction] = []
    
    fileprivate func run() {
        if actions.isEmpty { return }
        
        for act in actions {
            if act.finished == false {
                if act.isActing == true { return }
                act.isActing = true
                
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + act.duration, execute: { act.run() })
                break
            }
        }
        actions.removeAll(where: { $0.finished == true })
    }
    
    func action(_ action: VRAction) {
        actions.append(action)
    }
    
    func remove(key: String) {
        actions.removeAll(where: {$0.key == key})
    }
    
    func removeAll() {
        actions.removeAll()
    }
}

class VNode: VRActuable {
       
    func consume(node: VNode) { 
        fatalError("This method in \(Self.Type.self) must be implemented by a subclass")
    }
    
    func execute() {
        run()
    }
    
    func kill() {
        removeAll()
    }
}

class VTemperature: VNode, VROperable {
    /**
     Amount of temperature (C°)
     */
    var quantity: CGFloat
    
    init(quantity: CGFloat) {
        self.quantity = quantity
    }
    
    override func consume(node: VNode) {
        if let water = node as? VWater { water.evaporate(self) }
    }
    
    static func *= (lhs: VTemperature, rhs: CGFloat) {
        lhs.quantity *= rhs
    }
    
    static func /= (lhs: VTemperature, rhs: CGFloat) {
        lhs.quantity /= rhs
    }
    
    static func -= (lhs: VTemperature, rhs: VTemperature) {
        lhs.quantity -= rhs.quantity
    }
    
    static func += (lhs: VTemperature, rhs: VTemperature) {
        lhs.quantity += rhs.quantity
    }
}

class VWater: VNode, VROperable {
    /**
     Amount of water (mm)
     */
    var quantity: CGFloat
    /**
     Space that water uses (m3)
     */
    var space: CGFloat
    var temperature: VTemperature
    
    init(quantity: CGFloat, perMeter3: CGFloat = 1.0, temperature: VTemperature = VTemperature(quantity: 30.0)) {
        if quantity < 0 || perMeter3 < 0 { fatalError("Amount of water must be greater or equals than zero") }
        if perMeter3 <= 0 { fatalError("Spaced taken by water must be greater than zero") }
        
        self.quantity = quantity
        self.space = perMeter3
        self.temperature = temperature
    }
    
    func quantityOf(space: CGFloat) -> VWater {
        VWater(quantity: space * self.space / quantity, perMeter3: space, temperature: temperature)
    }
    
    override func consume(node: VNode) {
        if let light = node as? VLight { evaporate(light.temperature) }
        if let ground = node as? VGround { ground.dip(self) }
    }
    
    /**
     Amount of water on some space, between 0% to 100%
     */
    func humidity() -> CGFloat {
        quantity / space
    }
    
    func evaporate(_ temperature: VTemperature) {
        self.temperature += temperature
        print(Self.Type.self, " ", temperature.quantity)
    }
    
    public static func +=(lhs: VWater, rhs: VWater) {
        lhs.quantity += rhs.quantity
        lhs.space += rhs.quantity
    }
    
    static func -= (lhs: VWater, rhs: VWater) {
        lhs.quantity -= rhs.quantity
        lhs.space -= rhs.quantity
    }
    
    static func *= (lhs: VWater, rhs: CGFloat) {
        lhs.quantity *= rhs
        lhs.space *= rhs
    }
    
    static func /= (lhs: VWater, rhs: CGFloat) {
        if rhs == 0 { fatalError("Could not divide per zero") }
        
        lhs.quantity /= rhs
        lhs.space /= rhs
    }
}

class VLight: VNode {
    var micromolesPerMeter2PerSecond: CGFloat
    var temperature: VTemperature
    var type: LType = .WHITE
    
    enum LType {
        case WHITE
        case BLACK
    }
    
    init(micromolesPerM2PerS: CGFloat, temperature: VTemperature) {
        self.micromolesPerMeter2PerSecond = micromolesPerM2PerS
        self.temperature = temperature
    }
    
    override func consume(node: VNode) {
        if let water = node as? VWater { water.consume(node: self) }
    }
}

class VNutrient: VNode {
    let name: String
    let symbol: String
    
    public static let N: VNutrient = VNutrient(name: "nitrogen", symbol: "N")
    public static let P: VNutrient = VNutrient(name: "phosphorus", symbol: "P2O5")
    public static let K: VNutrient = VNutrient(name: "pottasium", symbol: "K2O")
    
    init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
    }
    
    override func consume(node: VNode) {
        if let light = node as? VLight { heat(light.temperature)  }
    }
    
    func heat(_ temperature: VTemperature) {
        
    }
}

class VGround: VNode {
    let name: String
    let ph: CGFloat
    var weight: CGFloat
    var density: CGFloat
    /**
     It's the space taken by this ground
     */
    var space: CGFloat
    /**
     The capability to absorb water. It's a percentage of its weight
     */
    var waterAbsorption: VWater
    /**
     The capability to let flow the water (mm per second)
     */
    var waterFilter: VWater
    /**
     It's the water stored in this ground
     */
    var waterHeld: VWater = VWater(quantity: 0.0)
    var nutrients: [VNutrient] = []
    var cic: CGFloat
    
    public static let SANDY: VGround = VGround(name: "SANDY", ph: 6.0, weight: 1.0, density: 1.4, space: 1.0, waterAbsorption: VWater(quantity: 0.2), waterFilter: VWater(quantity: 0.0055), cic: 5)
    public static let SILT: VGround = VGround(name: "SILT", ph: 7.0, weight: 1.0, density: 1.2, space: 1.0, waterAbsorption: VWater(quantity: 0.4), waterFilter: VWater(quantity: 0.0022), cic: 15)
    public static let CLAY: VGround = VGround(name: "CLAY", ph: 7.5, weight: 1.0, density: 1.1, space: 1.0, waterAbsorption: VWater(quantity: 0.6), waterFilter: VWater(quantity: 0.00027), cic: 60)
    
    init(name: String, ph: CGFloat, weight: CGFloat, density: CGFloat, space: CGFloat, waterAbsorption: VWater, waterFilter: VWater, cic: CGFloat) {
        self.name = name
        self.ph = ph
        self.weight = weight
        self.density = density
        self.space = space
        self.waterAbsorption = waterAbsorption
        self.waterFilter = waterFilter
        self.cic = cic
    }
    
    override func consume(node: VNode) {
        if let nutrient = node as? VNutrient { absorb(nutrient) }
    }
    
    func absorb(_ nutrient: VNutrient) {
        nutrients.append(nutrient)
    }
    
    func dip(_ water: VWater) {
        waterHeld += water
        
        if space < waterHeld.space {
            let leaveSpace = waterHeld.space - space
            waterHeld -= waterHeld.quantityOf(space: leaveSpace)
        }
    }
}

class VPlant: VNode {
    let name: String
    var phases: [Phase] = []
    var currentPhase: Phase?
    fileprivate var secondsOfLive: CGFloat
    var age: CGFloat
    var status: Status
    var waterAbsorbed: VWater
    var temperature: VTemperature
    var nutrientsAbsorbed: [VNutrient] = []
    
    init(name: String, status: Status = .GOOD) {
        self.name = name
        self.secondsOfLive = 0.0
        self.age = 0.0
        self.status = status
        self.waterAbsorbed = VWater(quantity: 0)
        self.temperature = VTemperature(quantity: 0)
    }
    
    struct Consume <N> {
        var absorb: N
        var consume: N
        var needed: N
    }
    
    class Resilience: VRActuable {
        let toStatus: Status
        let condition: VNode
        let topLimit: Bool
        
        init(toStatus: Status, condition: VNode, topLimit: Bool) {
            self.toStatus = toStatus
            self.condition = condition
            self.topLimit = topLimit
        }
        
        override func run() {
            
        }
    }
    
    class Phase {
        let name: String
        var waterConsume: Consume<VWater>
        var lightConsume: Consume<VLight>
        var nutrientsConsume: Consume<[VNutrient]>
        let timeToGrowUp: CGFloat
        let start: CGFloat
        var ended: CGFloat?
        var resiliences: [Resilience] = []
        
        init(name: String, waterConsume: Consume<VWater>, lightConsume: Consume<VLight>, nutrientsConsume: Consume<[VNutrient]>, timeToGrowUp: CGFloat, start: CGFloat, ended: CGFloat? = nil, resiliences: [Resilience]) {
            self.name = name
            self.waterConsume = waterConsume
            self.lightConsume = lightConsume
            self.nutrientsConsume = nutrientsConsume
            self.timeToGrowUp = timeToGrowUp
            self.start = start
            self.ended = ended
            self.resiliences = resiliences
        }
    }
    
    struct Status {
        let name: String
        
        public static let GOOD:Status = Status(name: "GOOD")
    }
}

/*
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
*/
