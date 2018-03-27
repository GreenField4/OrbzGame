//
//  LevelScene.swift
//  Orbz
//
//  Created by Andrew Greenfield on 2018-03-23.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class LevelScene: SKScene,  SKPhysicsContactDelegate{
    let imgArrow = SKSpriteNode(imageNamed: "ornamented_arrow_0")
    let btnReserve = SKSpriteNode()
    let imgBarrier = SKSpriteNode()
    private let arrowAnchor = SKNode()
    var colorsUsed = Array<String>()
    var orbQueue = Array<Orb>()
    let level = LevelLoader.getNextLevel()
    var framesSinceLastTap = 0
    var shouldCountFramesSinceLastTap = false
    var reserveOrb: Orb?
    let frameTimerLimit = 5
    var orbMatrix: [[Orb?]] = Array(repeating: Array(repeating: nil, count: 15), count: 8)
    
    // Calculate screen position from row and column indices
    private func getOrbCoordinate(_ row: Int, _ col: Int) -> CGPoint
    {
        var orbX = (CGFloat(row) * GameConstants.OrbWidth / 1.2) + (GameConstants.OrbWidth / 2)
        
        if (col % 2 == 0)
        {
            orbX += GameConstants.OrbWidth / 2.35
        }
        
        let orbY = size.height - (GameConstants.OrbHeight / 2) - CGFloat(col * Int(GameConstants.OrbHeight - 15))
        
        return CGPoint(x: orbX, y: orbY)
    }
    
    // Calculate row and column indices from screen position
    private func getGridPosition(_ x: CGFloat, _ y: CGFloat, forInsertion: Bool = true) -> CGPoint
    {
        var gridY = floor(y / GameConstants.RowHeight)
        print("grid system")
        var xOffset = CGFloat(0)
        
        if ((gridY).truncatingRemainder(dividingBy: 2) == 1)
        {
            xOffset += GameConstants.OrbWidth / 2
        }
        
        print(xOffset)
        var gridX = floor((x + xOffset) / GameConstants.OrbWidth)
        print(gridX)
        print(gridY)
        
        // Only run this when we're trying to force a new Orb into the matrix instead of a simple lookup
        if forInsertion && (orbMatrix[Int(gridX)][Int(gridY)] != nil){
            print("boss")
            
//            if Int(gridY + 1) < orbMatrix.count && orbMatrix[Int(gridX)][Int(gridY + 1)] == nil
//            {
//                gridY += 1
//            }
            
            if (gridX+1 >= 0) && orbMatrix[Int(gridX + 1)][Int(gridY)] == nil
            {
                gridX += 1
            }
            else if (Int(gridX - 1) >= 0 && (Int(gridX - 1)) < orbMatrix[0].count) && orbMatrix[Int(gridX - 1)][Int(gridY)] == nil
            {
                gridX += -1
            }
            else
            {
                gridY += 1
            }
 
            print("Modified by boss")
            print(gridX)
            print(gridY)
            
        }
        
        return CGPoint(x: gridX, y: gridY)
    }
    
    private func layoutOrbs()
    {
        let orbColorMatrix = level.orbColorMatrix
        
        for row in 0..<orbColorMatrix.count
        {
            for col in 0..<orbColorMatrix[row].count
            {
                if orbColorMatrix[row][col] != ""
                {
                    colorsUsed.append(orbColorMatrix[row][col])
                    let currentOrb = Orb(color: orbColorMatrix[row][col], stuck: true)
                    currentOrb.position = getOrbCoordinate(col, row)
                
                    orbMatrix[row][col] = currentOrb
                    self.addChild(currentOrb)
                }
            }
        }
        
        print("Orb [0][0] X: \(orbMatrix[0][0]!.position.x)")
        print("Orb [0][1] X: \(orbMatrix[1][0]!.position.x)")
    }
    
    private func moveToNextLevel()
    {
        if LevelLoader.isGameBeaten()
        {
            // Do something here later
            print("Wow, you beat the game!")
        }
        else
        {
            let levelTransition = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.5)
            let nextLevelScene = LevelScene(size: self.size)
            self.view?.presentScene(nextLevelScene, transition: levelTransition)
        }
    }
    
    private func getNextPlayerOrb()
    {
        let nextOrb = Orb(color: colorsUsed[Int(arc4random_uniform(UInt32(colorsUsed.count)))])
        orbQueue.append(nextOrb)
        orbQueue.last?.position = CGPoint(x:self.frame.midX/4, y: GameConstants.OrbHeight/2)
        orbQueue[0].position = CGPoint(x:self.frame.midX, y:self.frame.minY)
        self.addChild(nextOrb)
    }
    
    private func initPlayerOrbs()
    {
        for _ in 0...1
        {
            getNextPlayerOrb()
        }
        //orbQueue[0].position = CGPoint(x:self.frame.midX, y:self.frame.minY)
    }
    
    private func resetClusterCheck()
    {
        for row in orbMatrix
        {
            for orb in row
            {
                orb?.checkedForCluster = false
            }
        }
    }
    
    private func getOrbNeighbours(_ orb: Orb, matchColour: Bool) -> Array<Orb>
    {
        var neighbourOrbs = Array<Orb>()
        let posInMatrix = getGridPosition(orb.position.x, self.frame.maxY - orb.position.y, forInsertion: false)
        let orbX = Int(posInMatrix.x)
        let orbY = Int(posInMatrix.y)
        
        let neighbourOffsets: [[Int]]
        
        if orbX % 2 == 0
        {
            // Checking for an even row orb
            neighbourOffsets = GameConstants.NeighbourOffsetTable[0]
        }
        else
        {
            // Checking for an odd row orb
            neighbourOffsets = GameConstants.NeighbourOffsetTable[1]
        }
        
        for i in 0..<neighbourOffsets.count
//        for i in 0..<GameConstants.NeighbourOffsetTable.count
        {
            let neighbourX = orbX + neighbourOffsets[i][0]
            let neighbourY = orbY + neighbourOffsets[i][1]
//            let neighbourX = orbX + GameConstants.NeighbourOffsetTable[i][0]
//            let neighbourY = orbY + GameConstants.NeighbourOffsetTable[i][1]
            
            if (neighbourX >= 0 && neighbourX < orbMatrix.count) && (neighbourY >= 0 && neighbourY < orbMatrix[0].count)
            {
                if let neighbour = orbMatrix[neighbourX][neighbourY]
                {
                    if !matchColour || (neighbour.colour == orb.colour)
                    {
//                        print("Found neighbour")
                        neighbourOrbs.append(neighbour)
                    }
                }
            }
        }
        
        return neighbourOrbs
    }
    
    // Search for orb clusters in the matrix starting from a specified location
    private func findOrbCluster(_ x: Int, _ y: Int, matchColour: Bool, reset: Bool) -> Array<Orb>
    {
        if reset
        {
            resetClusterCheck()
        }
        
        var foundCluster = Array<Orb>()
        
        if let startingOrb = orbMatrix[x][y]
        {
            startingOrb.checkedForCluster = true
            var orbsToProcess = Array<Orb>()
            orbsToProcess.append(startingOrb)
            
            while orbsToProcess.count > 0
            {
//                print("Getting current orb to check")
                let currentOrb = orbsToProcess.removeLast()
                
                if !matchColour || (currentOrb.colour == startingOrb.colour)
                {
                    foundCluster.append(currentOrb)
                    
                    let neighbourOrbs = getOrbNeighbours(currentOrb, matchColour: matchColour)
//                    print("Num neighbours: \(neighbourOrbs.count)")
                    for neighbour in neighbourOrbs
                    {
//                        print("neighbour checked: \(neighbour.checkedForCluster)")
                        if !neighbour.checkedForCluster
                        {
//                            print("Adding neighbour to process queue")
                            orbsToProcess.append(neighbour)
                            neighbour.checkedForCluster = true
                        }
                    }
                }
            }
        }
        
        return foundCluster
    }
    
    // Searches for orb clusters that are "floating"
    // i.e. not attached to the ceiling or any other row
    private func findFloatingClusters() -> Array<Array<Orb>>
    {
        resetClusterCheck()
        var allClusters = Array<Array<Orb>>()
        
        for i in 0..<orbMatrix.count
        {
            for j in 0..<orbMatrix[i].count
            {
                if let currentOrb = orbMatrix[i][j]
                {
                    if !currentOrb.checkedForCluster
                    {
                        let currentCluster = findOrbCluster(i, j, matchColour: false, reset: false)
                        
                        if currentCluster.count > 0
                        {
                            var clusterFloating = true
                            var k = 0
                            
                            while k < currentCluster.count && clusterFloating
                            {
                                for topRowOrb in orbMatrix[0]
                                {
                                    if topRowOrb != nil && currentCluster[k].position == topRowOrb!.position
                                    {
                                        // The orb is attached to the ceiling, therefore not floating
                                        clusterFloating = false
                                        break
                                    }
                                }
                                
                                k += 1
                            }
                            
                            if clusterFloating
                            {
                                allClusters.append(currentCluster)
                            }
                        }
                    }
                }
            }
        }
        
        return allClusters
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        var bodyA: SKPhysicsBody
        var bodyB: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            bodyA = contact.bodyA
            bodyB = contact.bodyB
        }
        else
        {
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        
        if (bodyA.categoryBitMask & GameConstants.CollisionCategories.Orb != 0) && (bodyB.categoryBitMask & GameConstants.CollisionCategories.StuckOrb != 0)
        {
            print("Orbs colliding")
            
            // Stop orb movement and change its collision category
            let collidingOrb = bodyA.node as! Orb
            collidingOrb.setOrbStuck(true)

            let xCenter = collidingOrb.position.x //+ GameConstants.OrbWidth / 4
            let yCenter = self.frame.maxY - collidingOrb.position.y //+ GameConstants.OrbHeight / 70
            
            // Determine how exactly bodyA hit bodyB (from the bottom? from the side?)
            let pos = getGridPosition(xCenter, yCenter)
            
            
            collidingOrb.removeFromParent()
            orbMatrix[Int(pos.x)][Int(pos.y)] = collidingOrb
            collidingOrb.position = getOrbCoordinate(Int(pos.x), Int(pos.y))
            self.addChild(collidingOrb)
            
            let cluster = findOrbCluster(Int(pos.x), Int(pos.y), matchColour: true, reset: true)
            
//            print("Cluster size: \(cluster.count)")
            if cluster.count >= 3
            {
//                print("cluster detected")
                
                for orb in cluster
                {
                    let orbPos = getGridPosition(orb.position.x, self.frame.maxY - orb.position.y, forInsertion: false)
                    orb.removeFromParent()
                    orbMatrix[Int(orbPos.x)][Int(orbPos.y)] = nil
                }
                
//                let floatingClusters = findFloatingClusters()
//                
//                for cluster in floatingClusters
//                {
//                    for orb in cluster
//                    {
//                        let orbPos = getGridPosition(orb.position.x, self.frame.maxY - orb.position.y)
//                        orb.removeFromParent()
//                        orbMatrix[Int(orbPos.x)][Int(orbPos.y)] = nil
//                    }
//                }
            }
        }
        
        if (bodyA.categoryBitMask & GameConstants.CollisionCategories.Orb != 0) && (bodyB.categoryBitMask & GameConstants.CollisionCategories.Barrier != 0)
        {
            print("ORB -> BARRIER")
            let collidingOrb = bodyA.node as! Orb
            collidingOrb.setOrbStuck(true)
            
            let xCenter = collidingOrb.position.x //+ GameConstants.OrbWidth / 4
            let yCenter = self.frame.maxY - collidingOrb.position.y //+ GameConstants.OrbHeight / 70
            
            // Determine how exactly bodyA hit bodyB (from the bottom? from the side?)
            let pos = getGridPosition(xCenter, yCenter)
            
            
            collidingOrb.removeFromParent()
            orbMatrix[Int(pos.x)][Int(pos.y)] = collidingOrb
            collidingOrb.position = getOrbCoordinate(Int(pos.x), Int(pos.y))
            self.addChild(collidingOrb)
            
            let cluster = findOrbCluster(Int(pos.x), Int(pos.y), matchColour: true, reset: true)
            
//            print("Cluster size: \(cluster.count)")
            if cluster.count >= 3
            {
                for orb in cluster
                {
                    let orbPos = getGridPosition(orb.position.x, self.frame.maxY - orb.position.y, forInsertion: false)
                    orb.removeFromParent()
                    orbMatrix[Int(orbPos.x)][Int(orbPos.y)] = nil
                }
                
//                let floatingClusters = findFloatingClusters()
//
//                for cluster in floatingClusters
//                {
//                    for orb in cluster
//                    {
//                        let orbPos = getGridPosition(orb.position.x, self.frame.maxY - orb.position.y)
//                        orb.removeFromParent()
//                        orbMatrix[Int(orbPos.x)][Int(orbPos.y)] = nil
//                    }
//                }
            }
        }
    }
    
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.black
        
        let bgNode = SKSpriteNode(imageNamed: level.bgTextureName)
        bgNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bgNode.isUserInteractionEnabled = false
        bgNode.zPosition = -1
        bgNode.size = CGSize(width: size.width, height: size.height)
        self.addChild(bgNode)
        
        // Set up arrow rotation anchor
        arrowAnchor.position = CGPoint(x: self.frame.midX, y: self.frame.minY)
        
        //shoot button created
        print("Shoot arrow created")
        imgArrow.name = "imgArrow"
        imgArrow.position = CGPoint(x: 0, y: 130)
        arrowAnchor.addChild(imgArrow)
        self.addChild(arrowAnchor)
        
        //Barrier one image created

        print("Barrier one image created")
//        imgBarrier.size = CGSize(width: self.frame.maxX, height: )

        print("Barrier image created")
        imgBarrier.size = CGSize(width: self.frame.maxX, height: self.frame.maxY )

        imgBarrier.name = "imgBarrier"
        imgBarrier.color = SKColor.darkGray
        imgBarrier.position = CGPoint(x:self.frame.midX, y:self.frame.midY + self.frame.maxY-1)
        imgBarrier.physicsBody = SKPhysicsBody(rectangleOf: imgBarrier.size) // define boundary of body
        imgBarrier.physicsBody?.isDynamic = true // 2
        imgBarrier.physicsBody?.categoryBitMask = GameConstants.CollisionCategories.Barrier //
        imgBarrier.physicsBody?.contactTestBitMask = GameConstants.CollisionCategories.Orb  // Contact with bullet
        imgBarrier.physicsBody?.collisionBitMask = 0x0 // No bouncing on collision
        self.addChild(imgBarrier)
        
        //Barrier one image created
        print("Barrier image created")
        btnReserve.size = CGSize(width: 80, height: 80 )
        btnReserve.name = "btnReserve"
        btnReserve.color = SKColor.white
        btnReserve.position = CGPoint(x:self.frame.maxX-40, y:self.frame.minY+40)
        self.addChild(btnReserve)
        
        // set the physical world
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        let nextOrbLabel = SKLabelNode()
        nextOrbLabel.text = "NEXT"
        nextOrbLabel.fontName = "AvenirNext-Bold"
        nextOrbLabel.fontSize = 25
        nextOrbLabel.fontColor = SKColor.white
        nextOrbLabel.position = CGPoint(x: size.width / 8, y: size.height / 14)
        self.addChild(nextOrbLabel)
        
        layoutOrbs()
        initPlayerOrbs()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        framesSinceLastTap = 0
        shouldCountFramesSinceLastTap = true
    }
    
    private func clamp(_ value: CGFloat) -> CGFloat
    {
        if value > CGFloat(0)
        {
            return CGFloat(1)
        }
        else
        {
            return CGFloat(-1)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let dragDirection = clamp(pointOfTouch.x - previousPointOfTouch.x)
            let rotationAngle = -(dragDirection * .pi/90)
            
            if (arrowAnchor.zRotation + rotationAngle > (52 * .pi/180) )
            {
                arrowAnchor.zRotation = (52 * .pi/180)
                
            }else if (arrowAnchor.zRotation + rotationAngle < (-52 * .pi/180)){
                arrowAnchor.zRotation = (-52 * .pi/180)
                
            }else{
                arrowAnchor.zRotation += rotationAngle
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if framesSinceLastTap <= frameTimerLimit
        {
            // Process "Tap" events, in this case
            let touch = touches.first as UITouch!
            let touchLocation = touch?.location(in: self)
            let nodes = self.nodes(at: touchLocation!)
            var foundOtherEvent = false
            
            shouldCountFramesSinceLastTap = false
            
            for node in nodes
            {
                if node.name == "btnReserve"
                {
                    print("Reserve box tapped")
                    
                    if reserveOrb == nil
                    {
                        print("Sending orb to empty reserve box")
                        reserveOrb = orbQueue.removeFirst()
                        getNextPlayerOrb()
                    }
                    else
                    {
                        print("Swapping with reserve box")
                        let temp = orbQueue[0]
                        orbQueue[0] = reserveOrb!
                        orbQueue[0].position = CGPoint(x:self.frame.midX, y:self.frame.minY)
                        reserveOrb = temp
                    }
                    
                    reserveOrb!.position = CGPoint(x: size.width - size.width/10, y: size.height/18)
                    foundOtherEvent = true
                }
            }
            
            if !foundOtherEvent
            {
                fire(angle: arrowAnchor.zRotation, orb: orbQueue.removeFirst(), maxX: self.frame.maxX, maxY: self.frame.maxY)
                print(imgArrow.position)
                getNextPlayerOrb()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if shouldCountFramesSinceLastTap
        {
            framesSinceLastTap += 1
        }
    }
}
