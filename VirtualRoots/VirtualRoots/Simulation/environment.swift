//
//  environment.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 01/03/24.
//

import Foundation

public protocol VROperation: AdditiveArithmetic {
    static var zero: Self { get }
    static func - (lhs: Self, rhs: Self) -> Self
    static func + (lhs: Self, rhs: Self) -> Self
    static func * (lhs: Self, rhs: CGFloat) -> Self
    static func / (lhs: Self, rhs: CGFloat) -> Self
}

/**
This class is a ground floor
 */
public struct VRGround: VROperation {
    var ph: CGFloat
    /**
     ppm of nitrogen in the ground
     */
    var nitrogen: CGFloat
    /**
     ppm of phosphorus in the ground
     */
    var phosphorus: CGFloat
    /**
     ppm of phosphorus in the ground
     */
    var potassium: CGFloat
    
    public init(ph: CGFloat, nitrogen: CGFloat, phosphorus: CGFloat, potassium: CGFloat) {
        self.ph = ph
        self.nitrogen = nitrogen
        self.phosphorus = phosphorus
        self.potassium = potassium
    }
    
    public enum GType {
        case ARCILLA(ph: CGFloat)
    }
    
    public static var zero: VRGround {
        return VRGround(ph: 0.0, nitrogen: 0.0, phosphorus: 0.0, potassium: 0.0)
    }
    
    public static func - (lhs: VRGround, rhs: VRGround) -> VRGround {
        return VRGround(ph: lhs.ph,
                        nitrogen: lhs.nitrogen - rhs.nitrogen,
                        phosphorus: lhs.phosphorus - rhs.phosphorus,
                        potassium: lhs.potassium - rhs.potassium)
    }
    
    public static func + (lhs: VRGround, rhs: VRGround) -> VRGround {
        return VRGround(ph: lhs.ph,
                        nitrogen: lhs.nitrogen + rhs.nitrogen,
                        phosphorus: lhs.phosphorus + rhs.phosphorus,
                        potassium: lhs.potassium + rhs.potassium)
    }
    
    public static func * (lhs: VRGround, rhs: CGFloat) -> VRGround {
        return VRGround(ph: lhs.ph, nitrogen: lhs.nitrogen * rhs, phosphorus: lhs.phosphorus * rhs, potassium: lhs.potassium * rhs)
    }
    
    public static func / (lhs: VRGround, rhs: CGFloat) -> VRGround {
        guard rhs != 0 else {
            fatalError("Division per zero")
        }
        return VRGround(ph: lhs.ph,
                        nitrogen: lhs.nitrogen / rhs,
                        phosphorus: lhs.phosphorus / rhs,
                        potassium: lhs.potassium / rhs)
    }
}

public struct VRAtmosphere: VROperation {
    /**
     Porcentage between 0 at 100
     */
    var humidity: CGFloat
    /**
     ppm of carbon dioxide
     */
    var carbonDioxide: CGFloat
    // could be more variables
    
    public init(humidity: CGFloat, carbonDioxide: CGFloat) {
        self.humidity = humidity
        self.carbonDioxide = carbonDioxide
    }
    
    public static var zero: VRAtmosphere {
        get { return VRAtmosphere(humidity: 0.0, carbonDioxide: 0.0) }
    }
    
    public static func + (lhs: VRAtmosphere, rhs: VRAtmosphere) -> VRAtmosphere {
        return VRAtmosphere(humidity: lhs.humidity + rhs.humidity,
                            carbonDioxide: lhs.carbonDioxide + rhs.carbonDioxide)
    }
    
    public static func - (lhs: VRAtmosphere, rhs: VRAtmosphere) -> VRAtmosphere {
        return VRAtmosphere(humidity: lhs.humidity - rhs.humidity,
                                   carbonDioxide: lhs.carbonDioxide - rhs.carbonDioxide)
    }
    
    public static func * (lhs: VRAtmosphere, rhs: CGFloat) -> VRAtmosphere {
        return VRAtmosphere(humidity: lhs.humidity * rhs,
                            carbonDioxide: lhs.carbonDioxide * rhs)
    }
    
    public static func / (lhs: VRAtmosphere, rhs: CGFloat) -> VRAtmosphere {
        guard rhs != 0 else {
            fatalError("Division per zero")
        }
        
        return VRAtmosphere(humidity: lhs.humidity / rhs,
                            carbonDioxide: lhs.carbonDioxide / rhs)
    }
}

public struct VREnvironment: VROperation {
    /**
     quantity of light getting to the plant. (Micromoles per square meter per second)
     */
    var light: CGFloat
    /**
     temperature on environment (Celsius)
     */
    var temperature: CGFloat
    
    var ground: VRGround
    var atmosphere: VRAtmosphere
    var environmentSecondsElapsed: CGFloat = 0.0
    
    public init(light: CGFloat, temperature: CGFloat, ground: VRGround, atmosphere: VRAtmosphere) {
        self.light = light
        self.temperature = temperature
        self.ground = ground
        self.atmosphere = atmosphere
    }
    
    public func print() {
        Swift.print("light: \(light)\n")
        Swift.print("temperature: \(temperature)\n")
        Swift.print("ground.ph: \(ground.ph)\n")
        Swift.print("ground.N: \(ground.nitrogen)\n")
        Swift.print("ground.P: \(ground.phosphorus)\n")
        Swift.print("ground.K: \(ground.potassium)\n")
        Swift.print("atmosphere.humidity: \(atmosphere.humidity)\n")
        Swift.print("atmosphere.co2: \(atmosphere.carbonDioxide)\n")
        Swift.print("elapsed: \(environmentSecondsElapsed)\n\n")
    }
    
    public static var zero: VREnvironment {
        get { return VREnvironment(light: 0.0, temperature: 0.0, ground: .zero, atmosphere: .zero) }
    }
    
    public static func + (lhs: VREnvironment, rhs: VREnvironment) -> VREnvironment {
        return VREnvironment(light: lhs.light + rhs.light,
                             temperature: lhs.temperature + rhs.temperature,
                             ground: lhs.ground + rhs.ground,
                             atmosphere: lhs.atmosphere + rhs.atmosphere)
    }
    
    public static func - (lhs: VREnvironment, rhs: VREnvironment) -> VREnvironment {
        return VREnvironment(light: lhs.light - rhs.light,
                             temperature: lhs.temperature - rhs.temperature,
                             ground: lhs.ground - rhs.ground,
                             atmosphere: lhs.atmosphere - rhs.atmosphere)
    }
    
    public static func * (lhs: VREnvironment, rhs: CGFloat) -> VREnvironment {
        return VREnvironment(light: lhs.light * rhs,
                             temperature: lhs.temperature * rhs,
                             ground: lhs.ground * rhs,
                             atmosphere: lhs.atmosphere * rhs)
    }
    
    public static func / (lhs: VREnvironment, rhs: CGFloat) -> VREnvironment {
        guard rhs != 0 else {
            fatalError("Division per zero")
        }
        
        return VREnvironment(light: lhs.light / rhs,
                             temperature: lhs.temperature / rhs,
                             ground: lhs.ground / rhs,
                             atmosphere: lhs.atmosphere / rhs)
    }
}
