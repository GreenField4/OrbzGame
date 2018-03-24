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
    
    init(color: String)
    {
        self.colour = color
        let texture = GameConstants.orbTextureAtlas.textureNamed(color)
        super.init(texture: texture, color: SKColor.clear, size: CGSize(width: texture.size().width / 2, height: texture.size().height / 2))
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
//        self.physicsBody?.categoryBitMask = GameConstants.CollisionCategories.Player
//        self.physicsBody?.contactTestBitMask = GameConstants.CollisionCategories.InvaderBullet | GameConstants.CollisionCategories.Invader
        self.physicsBody?.collisionBitMask = 0x0
        
        self.name = "Orb - " + colour
        self.isUserInteractionEnabled = false
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
