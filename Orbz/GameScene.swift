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
        btnPlay.fontColor = SKColor.white
        btnPlay.fontSize = 60
        btnPlay.text = "PLAY"
        btnPlay.name = "btnPlay"
        btnPlay.position =  CGPoint(x:self.frame.midX, y:self.frame.midY+200);
        self.addChild(btnPlay)
        
        //instruction button
        print("Instruction button created")
        btnControls.fontColor = SKColor.white
        btnControls.fontSize = 50
        btnControls.text = "Controls"
        btnControls.name = "btnControls"
        btnControls.position =  CGPoint(x:self.frame.midX, y:self.frame.midY+100);
        self.addChild(btnControls)
        
        print("Play Music button created")
        btnToggleMute.fontColor = SKColor.white
        btnToggleMute.fontSize = 40
        btnToggleMute.text = "Toggle Mute"
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
        for t: AnyObject in touches {
            let location = t.location(in: self)
            let theNode = self.atPoint(location)
            if theNode.name == btnControls.name {
                print("The Instruction button was touched")
                let transition = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.5)
                let gameScene = ControlScene(size: self.size);
                self.view?.presentScene(gameScene, transition: transition)
            } else if theNode.name == btnPlay.name {
                print("The play button was touched")
                let transition = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.5)
                let gameScene = LevelScene(size: self.size);
                self.view?.presentScene(gameScene, transition: transition)
            }else{
                print("outside area")
            }
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
