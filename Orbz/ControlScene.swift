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
        let lblInstructionTitle = SKLabelNode(fontNamed: "Courier")
        lblInstructionTitle.fontColor = SKColor.white
        lblInstructionTitle.fontSize = 20
        lblInstructionTitle.text = "Instructions"
        lblInstructionTitle.position =  CGPoint(x:self.frame.midX, y:self.frame.maxY-100);
        lblInstructionTitle.numberOfLines = 0
        self.addChild(lblInstructionTitle)
        
        //instruction label
        let lblInstruction = SKLabelNode(fontNamed: "Courier")
        lblInstruction.fontColor = SKColor.white
        lblInstruction.fontSize = 11
        lblInstruction.text = "Each level consists of some sort of \narrangement of different coloured orbs \n(red, green, yellow, orange, etc). \nThe player’s goal is to clear the screen of all \norbs to progress to the next level. \nTo clear orbs, players must match \nfour or more of the same coloured orbs. \nThe player loses, \nhowever, if the player’s \nsprite comes into contact with any \nof the orbs in the level."
        lblInstruction.position =  CGPoint(x:self.frame.midX, y:self.frame.maxY-300);
        lblInstruction.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        lblInstruction.numberOfLines = 0
        self.addChild(lblInstruction)
        
        //Control Title label
        let lblControlsTitle = SKLabelNode(fontNamed: "Courier")
        lblControlsTitle.fontColor = SKColor.white
        lblControlsTitle.fontSize = 20
        lblControlsTitle.text = "Controls"
        lblControlsTitle.position =  CGPoint(x:self.frame.midX, y:self.frame.maxY-400);
        lblControlsTitle.numberOfLines = 0
        self.addChild(lblControlsTitle)
        
        //instruction label
        let lblControls = SKLabelNode(fontNamed: "Courier")
        lblControls.fontColor = SKColor.white
        lblControls.fontSize = 13
        lblControls.text = "Swipe Left -> Rotate cannon counterclockwise \nSwipe Right -> Rotate cannon clockwise \nTap Screen -> Shoot \nTap Pause Button -> Display Pause Menu \nTap Reserve Box -> Switch Orb with Reserve"
        lblControls.position =  CGPoint(x:self.frame.midX, y:self.frame.maxY - 500);
        lblControls.numberOfLines = 0
        self.addChild(lblControls)
        //back button
        btnBack.fontColor = SKColor.white
        btnBack.fontSize = 20
        btnBack.text = "Back"
        btnBack.name = "btnBack"
        btnBack.position =  CGPoint(x:self.frame.midX, y:self.frame.maxY-650);
        self.addChild(btnBack)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let theNode = self.atPoint(location)
            //back button was pressed
            if theNode.name == btnBack.name {
                let transition = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.5)
                let gameScene = TitleScene(size: self.size);
                self.view?.presentScene(gameScene, transition: transition)
            } else {
            }
        }
    }
}

