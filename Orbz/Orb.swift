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
    var checkedForCluster: Bool // Whether or not this orb has already been considered in cluster checks
    var x: Int?
    var y: Int?
    
    init(color: String, stuck: Bool = false, checked: Bool = false)
    {
        self.colour = color
        let texture = GameConstants.orbTextureAtlas.textureNamed(color)
        self.checkedForCluster = checked
        super.init(texture: texture, color: SKColor.clear, size: CGSize(width: GameVariables.OrbWidth, height: GameVariables.OrbHeight))
        
        //self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody = SKPhysicsBody(circleOfRadius: GameVariables.OrbWidth / 2.5)
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
        aCoder.encode(checkedForCluster, forKey: "checked")
        super.encode(with: aCoder)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.colour = aDecoder.decodeObject(forKey: "colour") as! String
        self.checkedForCluster = aDecoder.decodeBool(forKey: "checked")
        super.init(coder: aDecoder)
    }
}
