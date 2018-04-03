//
//  GameScene.swift
//  Orbz
//
//  Created by Andrew Greenfield on 2018-03-22.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import SpriteKit
import GameplayKit

class TitleScene: SKScene {
    
    let btnToggleMute = SKLabelNode(fontNamed: "Courier")
    let btnPlay = SKLabelNode(fontNamed: "Courier")
    let btnControls = SKLabelNode(fontNamed: "Courier")
   
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        let imgLogo = SKSpriteNode(imageNamed: "logo")
        imgLogo.size = CGSize(width: self.frame.maxX - 100, height: 100 )
        imgLogo.name = "imgLogo"
        imgLogo.color = SKColor.white
        imgLogo.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 200)
        self.addChild(imgLogo)
        
        //play button
        btnPlay.fontColor = SKColor.white
        btnPlay.fontSize = 30
        btnPlay.text = "PLAY"
        btnPlay.name = "btnPlay"
        btnPlay.position =  CGPoint(x:self.frame.midX, y:self.frame.midY+100);
        self.addChild(btnPlay)
        
        //instruction button

        btnControls.fontColor = SKColor.white
        btnControls.fontSize = 30
        btnControls.text = "Controls"
        btnControls.name = "btnControls"
        btnControls.position =  CGPoint(x:self.frame.midX, y:self.frame.midY);
        self.addChild(btnControls)
        
        btnToggleMute.fontColor = SKColor.white
        btnToggleMute.fontSize = 30
        btnToggleMute.text = "Toggle Mute"
        btnToggleMute.name = "btnToggleMute"
        btnToggleMute.position =  CGPoint(x:self.frame.midX, y:self.frame.midY-100);
        self.addChild(btnToggleMute)
        
        AudioManager.playBGM(named: "titlescene")
        
        GameVariables.curScore = 0
        LevelLoader.resetLevelProgress()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t: AnyObject in touches {
            let location = t.location(in: self)
            let theNode = self.atPoint(location)
            if theNode.name == btnControls.name {
                let transition = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.5)
                let gameScene = ControlScene(size: self.size);
                self.view?.presentScene(gameScene, transition: transition)
            } else if theNode.name == btnPlay.name {
                let transition = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.5)
                let gameScene = LevelScene(size: self.size);
                self.view?.presentScene(gameScene, transition: transition)
            }else if theNode.name == btnToggleMute.name{
                AudioManager.toggleMute()
            }
        }
    }
}
