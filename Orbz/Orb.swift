//
//  Orb.swift
//  Orbz
//
//  Created by Bradley Katz on 2018-03-23.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import Foundation
import SpriteKit

class Orb: SKSpriteNode
{
    let colour: String
    var stuck: Bool
    
    init(color: String, stuck: Bool = false)
    {
        self.stuck = stuck
        self.colour = color
        let texture = GameConstants.orbTextureAtlas.textureNamed(color)
        super.init(texture: texture, color: SKColor.clear, size: CGSize(width: texture.size().width / 2, height: texture.size().height / 2))
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        
        if self.stuck
        {
            self.physicsBody?.categoryBitMask = GameConstants.CollisionCategories.StuckOrb
            self.physicsBody?.contactTestBitMask = GameConstants.CollisionCategories.Orb
        }
        else
        {
            self.physicsBody?.categoryBitMask = GameConstants.CollisionCategories.Orb
            self.physicsBody?.contactTestBitMask = GameConstants.CollisionCategories.StuckOrb | GameConstants.CollisionCategories.Barrier
        }
        
        self.physicsBody?.collisionBitMask = 0x0
        
        self.name = "Orb - " + colour
        self.isUserInteractionEnabled = false
    }
    
    public func setOrbStuck(_ stuck: Bool)
    {
        self.stuck = stuck
        self.physicsBody?.categoryBitMask = GameConstants.CollisionCategories.StuckOrb
        self.physicsBody?.contactTestBitMask = GameConstants.CollisionCategories.Orb
    }
    
    override func encode(with aCoder: NSCoder)
    {
        aCoder.encode(colour, forKey: "colour")
        aCoder.encode(stuck, forKey: "stuck")
        super.encode(with: aCoder)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.colour = aDecoder.decodeObject(forKey: "colour") as! String
        self.stuck = aDecoder.decodeBool(forKey:  "stuck")
        super.init(coder: aDecoder)
    }
}
