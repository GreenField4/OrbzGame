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

class LevelScene: SKScene,  SKPhysicsContactDelegate{
    let imgArrow = SKSpriteNode(imageNamed: "ornamented_arrow_0")
    let btnReserve = SKSpriteNode()
    let imgBarrior = SKSpriteNode()
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        //shoot button created
        print("Shoot arrow created")
        imgArrow.name = "imgArrow"
        imgArrow.position = CGPoint(x:self.frame.midX, y:self.frame.minY+130)
        self.addChild(imgArrow)
        
        //Barrior one image created
        print("Barrior image created")
        imgBarrior.size = CGSize(width: self.frame.maxX, height: self.frame.maxY )
        imgBarrior.name = "imgBarrior"
        imgBarrior.color = SKColor.darkGray
        imgBarrior.position = CGPoint(x:self.frame.midX, y:self.frame.midY + self.frame.maxY-1)
        imgBarrior.physicsBody = SKPhysicsBody() // define boundary of body
        imgBarrior.physicsBody?.isDynamic = true // 2
        imgBarrior.physicsBody?.categoryBitMask = PhysicsCategory.Barrior //
        imgBarrior.physicsBody?.contactTestBitMask = PhysicsCategory.Orb  // Contact with bullet
        imgBarrior.physicsBody?.collisionBitMask = PhysicsCategory.None // No bouncing on collision
        self.addChild(imgBarrior)
        
        //Barrior one image created
        print("Barrior image created")
        btnReserve.size = CGSize(width: 200, height: 200 )
        btnReserve.name = "btnReserve"
        btnReserve.color = SKColor.white
        btnReserve.position = CGPoint(x:self.frame.maxX-100, y:self.frame.minY+100)
        self.addChild(btnReserve)
        
        // set the physical world
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
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
