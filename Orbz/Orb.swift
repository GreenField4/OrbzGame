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
    
    init(color: String, stuck: Bool = false)
    {
        self.colour = color
        let texture = GameConstants.orbTextureAtlas.textureNamed(color)
        super.init(texture: texture, color: SKColor.clear, size: CGSize(width: texture.size().width / 1.2, height: texture.size().height / 1.2))
        
        //self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody = SKPhysicsBody(circleOfRadius: GameConstants.OrbWidth / 2.25)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        if stuck
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
        self.removeAllActions()
        self.physicsBody?.categoryBitMask = GameConstants.CollisionCategories.StuckOrb
        self.physicsBody?.contactTestBitMask = GameConstants.CollisionCategories.Orb
    }
    
    override func encode(with aCoder: NSCoder)
    {
        aCoder.encode(colour, forKey: "colour")
        super.encode(with: aCoder)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.colour = aDecoder.decodeObject(forKey: "colour") as! String
        super.init(coder: aDecoder)
    }
}
