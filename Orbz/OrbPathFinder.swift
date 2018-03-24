//
//  OrbPathFinder.swift
//  Orbz
//
//  Created by Andrew Greenfield on 2018-03-23.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

func fire(angle : CGFloat, orb : SKSpriteNode, maxX: CGFloat, maxY :CGFloat) {
    let x = cos(angle + .pi/2)
    let y = sin(angle + .pi/2)
    var direction = CGVector(dx: x,dy: y)
    if x == 0{
        // 9 - Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: (maxX/2), y: maxY), duration: 2.0)
        orb.run(SKAction.sequence([actionMove]))
    }else {
        let scalor = abs(((maxX/2)-GameConstants.OrbWidth/2)/direction.dx)
        direction =  CGVector(dx: direction.dx * scalor,dy: direction.dy * scalor)
        let initalMove = SKAction.moveBy(x: direction.dx, y: direction.dy, duration: 1)
        direction = CGVector(dx: (direction.dx * 2),dy: direction.dy * 2)
        let revDirection = CGVector(dx: 0 - direction.dx,dy: direction.dy)
        let normalDirection = SKAction.moveBy(x: direction.dx, y: direction.dy, duration: 1)
        let revDirectionMove = SKAction.moveBy(x: revDirection.dx, y: revDirection.dy, duration: 1)
        let missAction = SKAction.run() {
            orb.run(SKAction.repeatForever(SKAction.sequence([revDirectionMove, normalDirection])))
        }
        orb.run(SKAction.sequence([initalMove, missAction]))
    }
}
