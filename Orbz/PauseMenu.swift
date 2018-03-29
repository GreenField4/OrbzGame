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
//    let resumeButton:
    
    public override init()
    {
        super.init()
        
        self.isHidden = false
        
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
    }
}
