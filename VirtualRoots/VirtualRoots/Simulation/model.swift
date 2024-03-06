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
        
        isActing = false
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
        let actions = actions
            .filter({ $0.isLoopeable == false })
        if actions.isEmpty { return }
        
        for act in actions {
            if act.finished == true { continue }
            if act.isActing == true { return }
            
            act.isActing = true
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + act.duration, execute: { act.run() })
            break
        }
        self.actions
            .removeAll(where: { $0.finished == true })
    }
    
    fileprivate func runLoopers() {
        let loopers = actions
            .filter({$0.isLoopeable == true})
        
        loopers.forEach({ l -> Void in
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + l.duration, execute: { l.run() })
        })
    }
    
    func act(action: VRAction) {
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
        runLoopers()
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
    
    public static let ENVIRONMENT: VTemperature = VTemperature(quantity: 30.0)
    
    init(quantity: CGFloat) {
        self.quantity = quantity
    }
    
    override func consume(node: VNode) {
        if let water = node as? VWater { water.warm(self) }
    }
    
    func getCloseTo(_ anotherTemp: VTemperature) {
        if anotherTemp.quantity == quantity { return }
        let difference = (anotherTemp.quantity - quantity) / 2
        
        if abs(difference) < 1 { quantity = anotherTemp.quantity }
        else { quantity += difference }
    }
    
    static func == (lhs: VTemperature, rhs: VTemperature) -> Bool {
        return lhs.quantity == rhs.quantity
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
        if rhs.quantity == lhs.quantity { return }
        let difference = rhs.quantity - lhs.quantity
        let intensity = difference / 2.0
        
        if abs(intensity) < 1 { lhs.quantity = rhs.quantity }
        else { lhs.quantity += intensity }
    }
}

class VWater: VNode, VROperable {
    /**
     Amount of water (mm)
     */
    var quantity: CGFloat {
        didSet { if quantity < 0 { fatalError("Amount of water must be greater or equals than zero") } }
    }
    /**
     Space that water uses (m3)
     */
    var space: CGFloat
    /**
     Amount of water on some space, between 0% to 100%
     */
    var humidity: CGFloat { quantity / space }
    
    var temperature: VTemperature
    var state: State { temperature.quantity <= 0 ? .SOLID : temperature.quantity >= 100.0 ? .GAS : .FLUID }
    
    enum State {
        case SOLID
        case FLUID
        case GAS
    }
    
    public static let BOILING_POINT: CGFloat = 100.0
    
    init(quantity: CGFloat, space: CGFloat = 1.0, temperature: VTemperature = .ENVIRONMENT) {
        self.quantity = quantity
        self.space = space
        self.temperature = temperature
    }
    
    /**
     Change water space param to this water space, otherwise, transform the units of the water provides to this water
     */
    public static func cast(lhw: VWater, rhw: VWater) -> VWater {
        VWater(quantity: rhw.space * lhw.quantity / lhw.space, space: lhw.space)
    }
    
    func quantityOf(space: CGFloat) -> VWater {
        VWater(quantity: space * self.space / quantity, space: space, temperature: temperature)
    }
    
    override func consume(node: VNode) {
        if let light = node as? VLight { warm(light.temperature) }
        if let ground = node as? VGround { ground.dip(self) }
    }
    
    func warm(_ tempFelt: VTemperature) {
        temperature += tempFelt
        
        print(Self.Type.self, " ", self.temperature.quantity, " ", state)
    }
    
    public static func ==(lhs: VWater, rhs: VWater) -> Bool {
        lhs.quantity == rhs.quantity || lhs.space == rhs.quantity
    }
    
    public static func +=(lhs: VWater, rhs: VWater) {
        let rhw = VWater.cast(lhw: lhs, rhw: rhs)
        
        lhs.quantity += rhw.quantity
        lhs.space += rhw.space
        lhs.temperature += rhw.temperature
    }
    
    static func -= (lhs: VWater, rhs: VWater) {
        let rhw = VWater.cast(lhw: lhs, rhw: rhs)
        
        lhs.quantity -= rhw.quantity
        lhs.space -= rhw.space
        lhs.temperature += rhw.temperature
    }
    
    static func *= (lhs: VWater, rhs: CGFloat) {
        lhs.quantity *= rhs
        lhs.space *= rhs
        lhs.temperature *= rhs
    }
    
    static func /= (lhs: VWater, rhs: CGFloat) {
        if rhs == 0 { fatalError("Could not divide per zero") }
        
        lhs.quantity /= rhs
        lhs.space /= rhs
        lhs.temperature /= rhs
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
    
    init(quantity: CGFloat, temperature: VTemperature) {
        self.micromolesPerMeter2PerSecond = quantity
        self.temperature = temperature
    }
    
    override func consume(node: VNode) {
        if let water = node as? VWater { water.consume(node: self) }
        if let ground = node as? VGround { ground.warm(temperature) }
    }
}

class VNutrient: VNode, VROperable, Hashable {
    var hashValue: Int { symbol.hashValue }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol.hashValue)
    }
    
    static func *= (lhs: VNutrient, rhs: CGFloat) {
        lhs.quantity *= rhs
    }
    
    static func /= (lhs: VNutrient, rhs: CGFloat) {
        lhs.quantity /= rhs
    }
    
    static func -= (lhs: VNutrient, rhs: VNutrient) {
        lhs.quantity += rhs.quantity
    }
    
    static func += (lhs: VNutrient, rhs: VNutrient) {
        lhs.quantity -= rhs.quantity
    }
    
    static func == (lhs: VNutrient, rhs: VNutrient) -> Bool {
        lhs.symbol == rhs.symbol
    }
    
    let name: String
    let symbol: String
    var quantity: CGFloat
    
    public static let N: VNutrient = VNutrient(name: "nitrogen", symbol: "N")
    public static let P: VNutrient = VNutrient(name: "phosphorus", symbol: "P2O5")
    public static let K: VNutrient = VNutrient(name: "pottasium", symbol: "K2O")
    
    init(name: String, symbol: String, quantity: CGFloat = 0.0) {
        self.name = name
        self.symbol = symbol
        self.quantity = quantity
    }
    
    override func consume(node: VNode) {
        
    }
}

class VGround: VNode {
    let name: String
    let ph: CGFloat
    var weight: CGFloat
    var density: CGFloat {
        didSet { if density == 0 { fatalError("Density of ground must not be zero") } }
    }
    /**
     It's the space taken by this ground
     */
    var space: CGFloat {
        weight / density
    }
    var temperature: VTemperature
    
    private var waterPercentageAbsortion: CGFloat
    /**
     The capability to absorb water. It's a percentage of its weight
     */
    var waterAbsorption: VWater { VWater(quantity: weight * waterPercentageAbsortion) }
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
    
    public static let SANDY: VGround = VGround(name: "SANDY", ph: 6.0, weight: 0.0, density: 1.4, waterAbsorption: 0.2, waterFilter: VWater(quantity: 0.0055), cic: 5)
    public static let SILT: VGround = VGround(name: "SILT", ph: 7.0, weight: 0.0, density: 1.2, waterAbsorption: 0.4, waterFilter: VWater(quantity: 0.0022), cic: 15)
    public static let CLAY: VGround = VGround(name: "CLAY", ph: 7.5, weight: 0.0, density: 1.1, waterAbsorption: 0.6, waterFilter: VWater(quantity: 0.00027), cic: 60)
    
    init(name: String, ph: CGFloat, weight: CGFloat, density: CGFloat, waterAbsorption: CGFloat, waterFilter: VWater, cic: CGFloat, temperature: VTemperature = .ENVIRONMENT) {
        
        self.name = name
        self.ph = ph
        self.weight = weight
        self.density = density
        self.temperature = temperature
        self.waterPercentageAbsortion = waterAbsorption
        self.waterFilter = waterFilter
        self.cic = cic
        
        super.init()
        act(action: VRAction.repeat(key: "groundswater-filtering") {
            if self.waterHeld.quantity <= self.waterAbsorption.quantity { return }
            self.waterHeld -= self.waterFilter
        })
    }
    
    override func consume(node: VNode) {
        if let nutrient = node as? VNutrient { absorb(nutrient) }
    }
    
    func absorb(_ nutrient: VNutrient) {
        nutrients.append(nutrient)
    }
    
    func dip(_ water: VWater) {
        warm(water.temperature)
        
        if water.state != .FLUID { return }
        
        waterHeld += water
        if space >= waterHeld.space { return }
        
        let leaveSpace = waterHeld.space - space
        waterHeld -= waterHeld.quantityOf(space: leaveSpace)
    }
    
    func warm(_ tempFelt: VTemperature) {
        temperature += tempFelt
        //waterHeld.warm(tempFelt) water + water alredy plus temperatures
    }
}

class VPlant: VNode {
    let name: String
    var phases: [Phase] = []
    var currentPhase: Phase?
    
    fileprivate var secondsOfLive: CGFloat
    var age: CGFloat { secondsOfLive }
    var status: Status = .none
    
    var waterAbsorbed: VWater
    var temperature: VTemperature
    fileprivate var nutrientsAbsorbed: Set<VNutrient> = []
    
    var description: String?
    
    init(name: String, timeOfSimulation: CGFloat) {
        self.name = name
        self.secondsOfLive = 0.0
        self.waterAbsorbed = VWater(quantity: 0)
        self.temperature = VTemperature(quantity: 0)
        
        super.init()
        
        act(action: VRAction.repeat(key: "plant-growing", duration: timeOfSimulation) {
            self.secondsOfLive += timeOfSimulation
        })
        
        act(action: VRAction.repeat(key: "plant-absorbing-water", duration: timeOfSimulation) {
            guard let phase = self.currentPhase else { return }
            
            // if the consume of water is less than water absorbed
            if phase.waterConsume.consume.quantity > self.waterAbsorbed.quantity {
                // unless the min water must be provided, else do not drink
                if phase.waterConsume.needed.quantity > self.waterAbsorbed.quantity { return }
                
                self.waterAbsorbed -= phase.waterConsume.needed
                return
            }
            self.waterAbsorbed -= phase.waterConsume.consume
        })
        
        act(action: VRAction.repeat(key: "plant-absorbing-nutrient", duration: timeOfSimulation) {
            guard let phase = self.currentPhase else { return }
            
            phase.nutrientsConsume.consume.forEach({(nutConsume) -> Void in
                guard let nutAbsorbed = self.nutrientsAbsorbed
                    .reduce(nil, {$1 == nutConsume ? $1 : $0}) else { return }
                
                if nutConsume.quantity > nutAbsorbed.quantity {
                    guard let nutNeeded = phase.nutrientsConsume.needed
                        .reduce(nil, {$1 == nutConsume ? $1 : $0}) else { return }
                    
                    if nutNeeded.quantity > nutAbsorbed.quantity { return }
                    
                    nutAbsorbed -= nutNeeded
                    return
                }
                nutAbsorbed -= nutConsume
            })
        })
    }
    
    override func consume(node: VNode) {
        if let ground = node as? VGround { absorb(ground) }
    }
    
    func add(nutrient: VNutrient) {
        let inserted = nutrientsAbsorbed.insert(nutrient)
        if inserted.inserted == true { return }
        inserted.memberAfterInsert += nutrient
    }
    
    func add(phase: Phase) {
        if phases.isEmpty { currentPhase = phase }
        phases.append(phase)
        phase.resiliences.forEach({act(action: $0)})
    }
    
    func absorb(_ ground: VGround) {
        print("\(name) absorbing...")
    }
    
    struct Consume <N> {
        /**
         It is the average consume of N
         */
        var consume: N
        /**
         It is the minimun consumo of N that is needed
         */
        var needed: N
        
        init(consume: N, needed: N) {
            self.consume = consume
            self.needed = needed
        }
    }
    
    class Resilience: VRAction {
        /**
         Status that the plant will be if the resilience ends
         */
        let toStatus: Status
        /**
         The condition that the plant must be to start its resilience
         */
        let condition: () -> Bool
        
        init(key: String = "", duration: CGFloat, toStatus: Status, condition: @escaping () -> Bool,_ action: @escaping () -> Void) {
            self.toStatus = toStatus
            self.condition = condition
            
            super.init(key: key, duration: duration, action)
        }
        
        override func run() {
            if condition() == false { return }
            super.run()
        }
        
        public static func run(key: String = "", duration: CGFloat, toStatus: Status, condition: @escaping () -> Bool, _ action: @escaping () -> Void) -> Resilience {
            return Resilience(key: key, duration: duration, toStatus: toStatus, condition: condition, action)
        }
    }
    
    struct Phase {
        let name: String
        var waterConsume: Consume<VWater>
        var lightConsume: Consume<VLight>
        var nutrientsConsume: Consume<[VNutrient]>
        var maxAge: CGFloat
        var start: CGFloat = 0.0
        var ended: CGFloat?
        var resiliences: [Resilience] = []
        
        var description: String?
        var modelName: String
        
        init(name: String, waterConsume: Consume<VWater>, lightConsume: Consume<VLight>, nutrientsConsume: Consume<[VNutrient]>, maxAge: CGFloat, modelName: String) {
            self.name = name
            self.waterConsume = waterConsume
            self.lightConsume = lightConsume
            self.nutrientsConsume = nutrientsConsume
            self.maxAge = maxAge
            self.modelName = modelName
        }
    }
    
    /**
     The status of any plant, like dry,  wet, etc.
     */
    enum Status {
        case none
        case dry
        case normal
        case wet
    }
}
