//
//  PhysicsCatagory.swift
//  Orbz
//
//  Created by Andrew Greenfield on 2018-03-23.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let StuckOrb  : UInt32 = 0b1
    static let Barrier   : UInt32 = 0b10
    static let Orb       : UInt32 = 0b100
}
