//
//  Util.swift
//  VirtualRoots
//
//  Created by ADMIN UNACH on 04/03/24.
//

import Foundation

protocol VROperable {
    static func ==(lhs: Self, rhs: Self) -> Bool
    static func +=(lhs: Self, rhs: Self)
    static func -=(lhs: Self, rhs: Self)
    static func /=(lhs: Self, rhs: CGFloat)
    static func *=(lhs: Self, rhs: CGFloat)
}

struct Calculator {
    public static func gramesToKg(grames: CGFloat) -> CGFloat {
        grames / 1000.0
    }
    
    public static func gramesToTon(grames: CGFloat) -> CGFloat {
        gramesToKg(grames: grames) / 1000.0
    }
}
