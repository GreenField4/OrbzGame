//
//  GameConstants.swift
//  Orbz
//
//  Created by Bradley Katz on 2018-03-23.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import Foundation
import SpriteKit

struct GameConstants
{
    private init() {}
    
    private static let redOrbTexture = UIImage(named: "sphere_red")!
    private static let blueOrbTexture = UIImage(named: "sphere_blue")!
    private static let greenOrbTexture = UIImage(named: "sphere_green")!
    private static let yellowOrbTexture = UIImage(named: "sphere_golden")!
    private static let purpleOrbTexture = UIImage(named: "sphere_purple")!
    private static let orangeOrbTexture = UIImage(named: "sphere_orange")!
    private static let lightBlueOrbTexture = UIImage(named: "sphere_light_blue")!
    
    public static let orbTextureAtlas = SKTextureAtlas(dictionary: ["red":redOrbTexture, "blue":blueOrbTexture, "green":greenOrbTexture, "yellow":yellowOrbTexture, "purple":purpleOrbTexture, "orange":orangeOrbTexture, "lblue":lightBlueOrbTexture])
    
    public static let OrbWidth = redOrbTexture.size.width / 1.2
    public static let OrbHeight = redOrbTexture.size.height / 1.2
    public static let RowOffset = CGFloat(15.1063842773 * (5/3))
    public static let RowHeight = CGFloat(43)
    public static let StartRow = CGFloat(29.1666870117)
    
    public static let NeighbourOffsetTable = [[[0, -1], [1, -1], [-1, 0], [1, 0], [0, 1], [1, 1]], [[-1, -1], [0, -1], [-1, 0], [1, 0], [-1, 1], [0, 1]]]
    
    public static let MaxScore = 99999
    
    struct CollisionCategories
    {
        private init() {}
        
        static let None: UInt32 = 0
        static let Orb: UInt32 = 0x1 << 0
        static let StuckOrb: UInt32 = 0x1 << 1
        static let Barrier: UInt32 = 0x1 << 2
    }
}
