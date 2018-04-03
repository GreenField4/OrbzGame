//
//  PauseMenu.swift
//  Orbz
//
//  Created by Bradley Katz on 2018-03-29.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import Foundation
import SpriteKit

class PauseMenu: SKNode
{
    private let btnToggleMute = SKLabelNode(fontNamed: "Courier")
    private let btnResume = SKLabelNode(fontNamed: "Courier")
    private let btnQuit = SKLabelNode(fontNamed: "Courier")
    
    public var isGamePaused: Bool
    
    public override init()
    {
        isGamePaused = false
        super.init()
    }
    
    public func initPauseMenu()
    {
        self.position = CGPoint(x:0, y:0)
        self.zPosition = 1
        
        let menuBack = SKSpriteNode()
        menuBack.size = CGSize(width: self.scene!.frame.midX + 10, height: 300 )
        menuBack.color = SKColor.black
        menuBack.position = CGPoint(x:self.scene!.frame.midX, y:self.scene!.frame.midY)
        self.addChild(menuBack)
        
        //play button
        print("resume button created")
        btnResume.fontColor = SKColor.white
        btnResume.fontSize = 30
        btnResume.text = "Resume"
        btnResume.name = "btnResume"
        btnResume.position =  CGPoint(x:self.scene!.frame.midX, y:self.scene!.frame.midY+100);
        self.addChild(btnResume)
        
        //instruction button
        print("quit button created")
        btnQuit.fontColor = SKColor.white
        btnQuit.fontSize = 30
        btnQuit.text = "Quit"
        btnQuit.name = "btnQuit"
        btnQuit.position =  CGPoint(x:self.scene!.frame.midX, y:self.scene!.frame.midY);
        self.addChild(btnQuit)
        
        print("Play Music button created")
        btnToggleMute.fontColor = SKColor.white
        btnToggleMute.fontSize = 30
        btnToggleMute.text = "Toggle Mute"
        btnToggleMute.name = "btnToggleMute"
        btnToggleMute.position =  CGPoint(x:self.scene!.frame.midX, y:self.scene!.frame.midY-100);
        self.addChild(btnToggleMute)
        
        self.isHidden = true
        
        for node in self.children
        {
            node.isPaused = true
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func togglePauseMenuDisplay()
    {
        self.isHidden = !self.isHidden
        
        for node in self.children
        {
            node.isPaused = !node.isPaused
        }
    }
    
    public func toggleGamePaused()
    {
        togglePauseMenuDisplay()
        
        for node in scene!.children
        {
            if node != self
            {
                node.isPaused = !node.isPaused
            }
        }
        
        self.isGamePaused = !self.isGamePaused
    }
}
