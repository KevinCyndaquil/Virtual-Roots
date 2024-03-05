//
//  simulation.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 01/03/24.
//

import Foundation
import UIKit
import RealityKit

class UISimulationController: UIViewController {
    var timer: Timer?
    var simulation: VRSimulation?
    
    @objc fileprivate func simulate() {
        DispatchQueue.global(qos: .background).async {
            self.simulation?.start()
            DispatchQueue.main.async {
                self.label.text = self.label.text == "WORLD" ? "HELLO" : "WORLD"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = ARView(frame: UIScreen.main.bounds)
        
        label.frame = CGRect(origin: view.center, size: CGSize(width: 200, height: 50))
        label.text = "HELLO"
        label.textColor = .white
        
        view.addSubview(label)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        simulation = VRSimulation()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(simulate), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
        simulation?.end()
        simulation = nil
    }
    
    
    let label: UILabel = UILabel()
}

class VRSimulation {
    var nodes: [VNode] = []
    
    init() {
        initNodes()
    }
    
    fileprivate func initNodes() {
        let water: VWater = VWater(quantity: 100.0)
        let light: VLight = VLight(micromolesPerM2PerS: 20.0, temperature: VTemperature(quantity: -10))
        
        light.act(action: VRAction.repeat(duration: 2.0, {
            light.consume(node: water)
        }))
        
        let plant = VPlant(name: "corn", status: .init(name: "GOOD", phase: 0))
        let phase = VPlant.Phase(name: "BABY", waterConsume: VPlant.Consume(absorb: VWater(quantity: 10), consume: VWater(quantity: 10), needed: VWater(quantity: 10)), lightConsume: VPlant.Consume(absorb: VLight(micromolesPerM2PerS: 10, temperature: .ENVIRONMENT), consume: VLight(micromolesPerM2PerS: 10, temperature: .ENVIRONMENT), needed: VLight(micromolesPerM2PerS: 10, temperature: .ENVIRONMENT)), nutrientsConsume: VPlant.Consume(absorb: [.K, .N, .P], consume: [.K, .N, .P], needed: [.K, .N, .P]), timeToGrowUp: 10000)
        let ground:VGround = .CLAY
        ground.weight = 1.0
        plant.add(phase: phase)
        
        plant.act(action: VRAction.repeat {
            plant.absorb(ground)
        })
        
        nodes.append(contentsOf: [water, light])
    }
    
    func start() {
        nodes.forEach({$0.execute()})
    }
    
    func end() {
        nodes.forEach({ $0.kill() })
        nodes.removeAll()
    }
}

/*
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
*/
