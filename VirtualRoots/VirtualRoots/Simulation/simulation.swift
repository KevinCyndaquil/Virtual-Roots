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
        let light: VLight = VLight(quantity: 20.0, temperature: VTemperature(quantity: -10))
        
        light.act(action: VRAction.repeat(key: "light-warming-water", duration: 2.0, {
            light.consume(node: water)
        }))
        
        let ground:VGround = .CLAY
        ground.weight = 1.0
        
        let corn:Corn = Corn(name: "maiz1", timeOfSimulation: 1.0)
        
        corn.act(action: VRAction.repeat(key: "plant-absorbing-ground", duration: 1.0) {
            corn.absorb(ground)
        })
        
        corn.act(action: VRAction.repeat(key: "plant-absorbing-light", duration: 1.0) {
            corn.absorb(light)
            print(corn.status)
        })
        
        nodes.append(contentsOf: [water, light, corn, ground])
    }
    
    func start() {
        nodes.forEach({$0.execute()})
    }
    
    func end() {
        nodes.forEach({ $0.kill() })
        nodes.removeAll()
    }
}
