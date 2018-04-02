//
//  LevelEndScoreDisplay.swift
//  Orbz
//
//  Created by Bradley Katz on 2018-04-02.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import Foundation
import SpriteKit

class LevelEndScoreDisplay: SKNode
{
    private let curScoreLbl = SKLabelNode(fontNamed: "Courier")
    private let highScoreLbl = SKLabelNode(fontNamed: "Courier")
    private let winLoseMessageLbl = SKLabelNode(fontNamed: "Courier")
    
    public override init()
    {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func initLevelEndScoreDisplay()
    {
        self.position = CGPoint(x: 0, y: 0)
        self.zPosition = 1
        
        let menuBack = SKSpriteNode()
        menuBack.size = CGSize(width: self.scene!.frame.midX, height: 300 )
        menuBack.color = SKColor.black
        menuBack.position = CGPoint(x:self.scene!.frame.midX, y:self.scene!.frame.midY)
        self.addChild(menuBack)
        
        winLoseMessageLbl.fontSize = 30
        winLoseMessageLbl.position = CGPoint(x: self.scene!.frame.midX, y: self.scene!.frame.midY + 100)
        self.addChild(winLoseMessageLbl)
        
        curScoreLbl.text = "Score: \(GameVariables.curScore)"
        curScoreLbl.fontSize = 20
        curScoreLbl.position = CGPoint(x: self.scene!.frame.midX, y: self.scene!.frame.midY)
        self.addChild(curScoreLbl)
        
        highScoreLbl.text = "Best: \(GameVariables.highScore)"
        highScoreLbl.fontSize = 20
        curScoreLbl.position = CGPoint(x: self.scene!.frame.midX, y: self.scene!.frame.midY - 100)
        self.addChild(highScoreLbl)
        
        self.isHidden = true
    }
    
    public func triggerDisplay(gameOver: Bool)
    {
        var sfxName: String
        
        if gameOver
        {
            curScoreLbl.text = "Score: \(GameVariables.curScore)"
            highScoreLbl.text = "Best: \(GameVariables.highScore)"
            winLoseMessageLbl.text = "GAME OVER"
            winLoseMessageLbl.color = SKColor.red
            sfxName = "Defeat"
        }
        else
        {
            curScoreLbl.text = "Score: \(GameVariables.curScore)"
            highScoreLbl.text = "Best: \(GameVariables.highScore)"
            winLoseMessageLbl.text = "LEVEL CLEAR"
            winLoseMessageLbl.color = SKColor.yellow
            sfxName = "Victory"
        }
        
        self.isHidden = false
        AudioManager.stopBGM()
        
        if !GameVariables.toggleMute
        {
            AudioManager.playBGM(named: sfxName, loop: false)
        }
        
        let loadNextLevel = SKAction.run {
            if !gameOver
            {
                LevelLoader.moveToNextLevel(scene: self.scene!)
            }
            else
            {
                let levelTransition = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.5)
                let nextLevelScene = TitleScene(size: self.scene!.size)
                self.scene!.view?.presentScene(nextLevelScene, transition: levelTransition)
            }
        }

        self.run(SKAction.sequence([SKAction.wait(forDuration: 5), loadNextLevel]))
    }
}
