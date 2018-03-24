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
    print(x)
    print(y)
    var direction = CGVector(dx: x,dy: y)
    if x == 0{
        // 9 - Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: (maxX/2), y: maxY), duration: 2.0)
        orb.run(SKAction.sequence([actionMove]))
    }else {
        let scalor = abs(((maxX/2)-35)/direction.dx)
        print(scalor)
        direction =  CGVector(dx: direction.dx * scalor,dy: direction.dy * scalor)
        print(direction.dx)
        print(direction.dy)
        let initalMove = SKAction.move(to: CGPoint(x: (maxX/2) + direction.dx, y: direction.dy), duration: 1)
        direction = CGVector(dx: (direction.dx * 2) + 35,dy: direction.dy * 2)
        let revDirection = CGVector(dx: 0 - direction.dx,dy: direction.dy)
        let normalDirection = SKAction.move(by: direction, duration: 2)
        let revDirectionMove = SKAction.move(by: revDirection, duration: 2)
        orb.run(initalMove)
        orb.run(SKAction.repeatForever(SKAction.sequence([revDirectionMove, normalDirection])))
    }
}
