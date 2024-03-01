//
//  environment.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 01/03/24.
//

import Foundation


/**
This class is a ground floor
 */
public class VRGround {
    /**
     ph in the ground
     */
    var ph: Int
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
    
    public init(ph: Int, nitrogen: CGFloat, phosphorus: CGFloat, potassium: CGFloat) {
        self.ph = ph
        self.nitrogen = nitrogen
        self.phosphorus = phosphorus
        self.potassium = potassium
    }
    
    public enum GType {
        case ARCILLA
    }
}

public class VRAtmosphere {
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
}

public class VREnvironment {
    /**
     quantity of light getting to the plant. Micro moles per squared meter per second
     */
    var light: CGFloat
    /**
     temperature on environment in Celsius
     */
    var temperature: CGFloat
    /**
     It is the water irrigated to the plant, not rain, mm / day
     */
    var waterIrrigated: CGFloat
    var ground: VRGround
    var atmosphere: VRAtmosphere
    var environmentSecondsElapsed: CGFloat = 0.0
    
    public init(light: CGFloat, temperature: CGFloat, waterIrrigated: CGFloat, ground: VRGround, atmosphere: VRAtmosphere) {
        self.light = light
        self.temperature = temperature
        self.waterIrrigated = waterIrrigated
        self.ground = ground
        self.atmosphere = atmosphere
    }
}
