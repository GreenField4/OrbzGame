//
//  ControlScene.swift
//  Orbz
//
//  Created by Andrew Greenfield on 2018-03-23.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ControlScene: SKScene {
    let btnBack = SKLabelNode(fontNamed: "Courier")
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        //instruction Title label
        print("Instruction title label created")
        let lblInstructionTitle = SKLabelNode(fontNamed: "Courier")
        lblInstructionTitle.fontColor = SKColor.white
        lblInstructionTitle.fontSize = 20
        lblInstructionTitle.text = "Instructions"
        lblInstructionTitle.position =  CGPoint(x:self.frame.midX, y:self.frame.maxY-200);
        lblInstructionTitle.numberOfLines = 0
        self.addChild(lblInstructionTitle)
        
        //instruction label
        print("Instruction label created")
        let lblInstruction = SKLabelNode(fontNamed: "Courier")
        lblInstruction.fontColor = SKColor.white
        lblInstruction.fontSize = 20
        lblInstruction.text = "Each level consists of some sort of arrangement of \ndifferent coloured orbs (red, green, yellow, white, etc). \nThe player’s goal is to clear the screen of all \norbs to progress to the next level. \nTo clear orbs, players must match \nfour or more of the same coloured orbs. \nThe player loses, however, if the player’s \nsprite comes into contact with any of the orbs in the level."
        lblInstruction.position =  CGPoint(x:self.frame.midX, y:self.frame.maxY-400);
        lblInstruction.numberOfLines = 0
        self.addChild(lblInstruction)
        
        //Control Title label
        print("Control title label created")
        let lblControlsTitle = SKLabelNode(fontNamed: "Courier")
        lblControlsTitle.fontColor = SKColor.white
        lblControlsTitle.fontSize = 30
        lblControlsTitle.text = "Controls"
        lblControlsTitle.position =  CGPoint(x:self.frame.midX, y:self.frame.maxY-550);
        lblControlsTitle.numberOfLines = 0
        self.addChild(lblControlsTitle)
        
        //instruction label
        print("Controls label created")
        let lblControls = SKLabelNode(fontNamed: "Courier")
        lblControls.fontColor = SKColor.white
        lblControls.fontSize = 25
        lblControls.text = "Swipe Left -> Rotate cannon counterclockwise \nSwipe Right -> Rotate cannon clockwise \nTap Screen -> Shoot \nTap Pause Button -> Display Pause Menu \nTap Reserve Box -> Switch Orb with Reserve"
        lblControls.position =  CGPoint(x:self.frame.midX, y:self.frame.maxY - 700);
        lblControls.numberOfLines = 0
        self.addChild(lblControls)
        //back button
        print("Back button created")
        
        btnBack.fontColor = SKColor.white
        btnBack.fontSize = 20
        btnBack.text = "Back"
        btnBack.name = "btnBack"
        btnBack.position =  CGPoint(x:self.frame.midX, y:self.frame.maxY-850);
        self.addChild(btnBack)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let theNode = self.atPoint(location)
            //back button was pressed
            if theNode.name == btnBack.name {
                print("The back button was touched ")
                let transition = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.5)
                let gameScene = TitleScene(size: self.size);
                self.view?.presentScene(gameScene, transition: transition)
            } else {
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

