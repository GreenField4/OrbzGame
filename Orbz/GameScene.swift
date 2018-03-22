//
//  GameScene.swift
//  Orbz
//
//  Created by Andrew Greenfield on 2018-03-22.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let btnToggleMute = SKLabelNode(fontNamed: "Courier")
    let btnPlay = SKLabelNode(fontNamed: "Courier")
    let btnControls = SKLabelNode(fontNamed: "Courier")
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        //play button
        print("Play button created")
        btnPlay.fontColor = SKColor.black
        btnPlay.fontSize = 60
        btnPlay.text = "PLAY"
        btnPlay.name = "btnPlay"
        btnPlay.position =  CGPoint(x:self.frame.midX, y:self.frame.midY+200);
        self.addChild(btnPlay)
        
        //instruction button
        print("Instruction button created")
        btnControls.fontColor = SKColor.black
        btnControls.fontSize = 50
        btnControls.text = "Controls"
        btnControls.name = "btnControls"
        btnControls.position =  CGPoint(x:self.frame.midX, y:self.frame.midY+100);
        self.addChild(btnControls)
        
        print("Play Music button created")
        btnToggleMute.fontColor = SKColor.black
        btnToggleMute.fontSize = 40
        btnToggleMute.text = "Play Music"
        btnToggleMute.name = "btnToggleMute"
        btnToggleMute.position =  CGPoint(x:self.frame.midX, y:self.frame.midY);
        self.addChild(btnToggleMute)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
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
