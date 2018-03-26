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
    var speed = 2.0
    if x == 0{
        // 9 - Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: (maxX/2), y: maxY), duration: 2.0)
        orb.run(SKAction.sequence([actionMove]))
    }else {
        var scalor = abs(((maxX/2)-GameConstants.OrbWidth/2)/direction.dx)
        if (scalor * direction.dy) > maxY{
            scalor = abs((maxY-GameConstants.OrbWidth/2)/direction.dy)
        } else if (scalor * direction.dy) > (maxY/2){
            speed = 1.75
        }
        direction =  CGVector(dx: direction.dx * scalor,dy: direction.dy * scalor)
        let initalMove = SKAction.moveBy(x: direction.dx, y: direction.dy, duration: TimeInterval(speed))
        direction = CGVector(dx: (direction.dx * 2),dy: direction.dy * 2)
        let revDirection = CGVector(dx: 0 - direction.dx,dy: direction.dy)
        let normalDirection = SKAction.moveBy(x: direction.dx, y: direction.dy, duration: TimeInterval(speed * 2))
        let revDirectionMove = SKAction.moveBy(x: revDirection.dx, y: revDirection.dy, duration: TimeInterval(speed * 2))
        let missAction = SKAction.run() {
            orb.run(SKAction.repeatForever(SKAction.sequence([revDirectionMove, normalDirection])))
        }
        orb.run(SKAction.sequence([initalMove, missAction]))
    }
}
