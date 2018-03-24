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
    let imgBarrier = SKSpriteNode()
    let level = LevelLoader.getNextLevel()
    
    var orbMatrix = Array<Array<Orb>>()
    
    // Calculate screen position from row and column indices
    private func getOrbCoordinate(_ row: Int, _ col: Int) -> CGPoint
    {
        var orbX = (CGFloat(col) * GameConstants.OrbWidth / 1.2) + (GameConstants.OrbWidth / 2)
        
        if (row % 2 == 0)
        {
            orbX += GameConstants.OrbWidth / 2.35
        }
        
        let orbY = size.height - (GameConstants.OrbHeight / 2) - CGFloat(row * Int(GameConstants.OrbHeight - 8))
        
        return CGPoint(x: orbX, y: orbY)
    }
    
    // Calculate row and column indices from screen position
    private func getGridPosition(_ x: CGFloat, _ y: CGFloat) -> CGPoint
    {
        let gridY = floor(y / GameConstants.RowHeight)
        var xOffset = CGFloat(0)
        
        if ((gridY + GameConstants.RowOffset).truncatingRemainder(dividingBy: 2) == 0)
        {
            xOffset = GameConstants.OrbWidth / 2
        }
        
        let gridX = floor((x - xOffset) / GameConstants.OrbWidth)
        
        return CGPoint(x: gridX, y: gridY)
    }
    
    private func layoutOrbs()
    {
        let orbDataMatrix = level.orbDataMatrix
        
        for row in 0..<orbDataMatrix.count
        {
            var currentRow = Array<Orb>()
            
            for col in 0..<orbDataMatrix[row].count
            {
                let currentOrb = Orb(color: orbDataMatrix[row][col].color)
                currentOrb.position = getOrbCoordinate(row, col)
                
                currentRow.append(currentOrb)
                self.addChild(currentOrb)
            }
            
            orbMatrix.append(currentRow)
        }
    }
    
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.black
        //shoot button created
        print("Shoot arrow created")
        imgArrow.name = "imgArrow"
        imgArrow.position = CGPoint(x:self.frame.midX, y:self.frame.minY+130)
        self.addChild(imgArrow)
        
        //Barrier one image created

        print("Barrier one image created")
//        imgBarrier.size = CGSize(width: self.frame.maxX, height: )

        print("Barrier image created")
        imgBarrier.size = CGSize(width: self.frame.maxX, height: self.frame.maxY )

        imgBarrier.name = "imgBarrier"
        imgBarrier.color = SKColor.darkGray
        imgBarrier.position = CGPoint(x:self.frame.midX, y:self.frame.midY + self.frame.maxY-1)
        imgBarrier.physicsBody = SKPhysicsBody() // define boundary of body
        imgBarrier.physicsBody?.isDynamic = true // 2
        imgBarrier.physicsBody?.categoryBitMask = PhysicsCategory.Barrier //
        imgBarrier.physicsBody?.contactTestBitMask = PhysicsCategory.Orb  // Contact with bullet
        imgBarrier.physicsBody?.collisionBitMask = PhysicsCategory.None // No bouncing on collision
        self.addChild(imgBarrier)
        
        //Barrier one image created
        print("Barrier image created")
        btnReserve.size = CGSize(width: 200, height: 200 )
        btnReserve.name = "btnReserve"
        btnReserve.color = SKColor.white
        btnReserve.position = CGPoint(x:self.frame.maxX-100, y:self.frame.minY+100)
        self.addChild(btnReserve)
        
        // set the physical world
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        layoutOrbs()
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
