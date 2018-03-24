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

let LARGE:CGFloat = 1000.0

func fire(arrowLoc : CGPoint, orb : SkSpriteNode, maxX: CGFloat, maxY :CGFloat) {
    var direction = CGVector(dx: arrowLoc.x - (maxX/2),dy: arrowLoc.y)
    if arrowLoc.x == (maxX/2){
        // compute the real destination for the projectile
        let realDest = realDestination(orb.position, endPoint: touchLocation)
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        orb.run(SKAction.sequence(actionMove))
    }else {
        let scalor = abs(((maxX/2)-35)/direction.dx)
        direction =  CGVector(dx: direction.dx * scalor,dy: direction.dy * scalor)
        let initalMove = SKAction.move(by: direction, duration: 1)
        direction = CGVector(dx: direction.dx * 2+35,dy: direction.dy * 2)
        var revDirection = CGVector(dx: -direction.dx,dy: direction.dy)
        let normalDirection = SKAction.move(by: direction, duration: 2)
        let revDirectionMove = SKAction.move(by: direction, duration: 2)
        orb.run(SKAction.sequence([initalMove]))
        orb.run(SKAction.repeatForever(SKAction.sequence([revDirection, normalDirection])))
    }
}
