//
//  LevelScene.swift
//  Orbz
//
//  Created by Andrew Greenfield on 2018-03-23.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class LevelScene: SKScene {
    let imgArrow = SKSpriteNode(imageNamed: "ornamented_arrow_0")
    let btnReserve = SKSpriteNode(imageNamed: "Square_with_corners.svg")
    var imgBarrior = SKSpriteNode()
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        //shoot button created
        print("Shoot arrow created")
        imgArrow.name = "imgArrow"
        imgArrow.position = CGPoint(x:self.frame.midX, y:self.frame.minY+130)
        self.addChild(imgArrow)
        
        //Barrior one image created
        print("Barrior one image created")
//        imgBarrior.size = CGSize(width: self.frame.maxX, height: )
        imgBarrior.name = "imgBarrior"
        imgBarrior.position = CGPoint(x:(self.frame.minX + self.frame.midX)/2, y:self.frame.minY+246+100+54)
        imgBarrior.physicsBody = SKPhysicsBody() // define boundary of body
        imgBarrior.physicsBody?.isDynamic = true // 2
        imgBarrior.physicsBody?.categoryBitMask = PhysicsCategory.Barrior //
        imgBarrior.physicsBody?.contactTestBitMask = PhysicsCategory.Orb  // Contact with bullet
        imgBarrior.physicsBody?.collisionBitMask = PhysicsCategory.None // No bouncing on collision
        self.addChild(imgBarrior)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t: AnyObject in touches {
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
