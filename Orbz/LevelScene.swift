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
    let btnPause = SKSpriteNode(imageNamed: "Pause")
    let lblScore = SKLabelNode()
    private let arrowAnchor = SKNode()
    let pauseMenu = PauseMenu()
    var colorsUsed = Array<String>()
    var orbQueue = Array<Orb>()
    let level = LevelLoader.getNextLevel()
    var framesSinceLastTap = 0
    var shouldCountFramesSinceLastTap = false
    var reserveOrb: Orb?
    let frameTimerLimit = 5
    var orbMatrix: [[Orb?]] = Array(repeating: Array(repeating: nil, count: 8), count: 15)
    var totalDrop : CGFloat = 41
    let loseLineLocation = CGFloat(175)
    var dropSize: CGFloat = 0
    var processingPreviousShot: Bool = false
    var shotsTaken: Int = 0
    
    // Calculate screen position from row and column indices
    private func getOrbCoordinate(_ row: Int, _ col: Int, drop: CGFloat) -> CGPoint
    {
        var orbX = (CGFloat(col) * GameConstants.OrbWidth / 1.2) + (GameConstants.OrbWidth / 2)
        
        if (row % 2 != 0)
        {
            orbX += GameConstants.OrbWidth / 2.35
        }
        
        let orbY = size.height - (GameConstants.OrbHeight / 2) - CGFloat(row * Int(GameConstants.OrbHeight - 15)) - drop
        
        return CGPoint(x: orbX, y: orbY)
    }
    
    // Calculate row and column indices from screen position
    private func getGridPosition(_ x: CGFloat, _ y: CGFloat, drop: CGFloat) -> CGPoint
    {
        let gridY = floor((y - drop + 8.6 ) / GameConstants.RowHeight)
        //print("grid system")
        var xOffset = CGFloat(0)
        if ((gridY).truncatingRemainder(dividingBy: 2) == 1)
        {
            xOffset += GameConstants.OrbWidth / 2
        }
        
        //print(xOffset)
        let gridX = floor((x - xOffset) / (GameConstants.OrbWidth/1.2) )
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
                    if !colorsUsed.contains(orbColorMatrix[row][col])
                    {
                        colorsUsed.append(orbColorMatrix[row][col])
                    }
                    
                    let currentOrb = Orb(color: orbColorMatrix[row][col], stuck: true)
                    currentOrb.position = getOrbCoordinate(row, col, drop: totalDrop)
                    currentOrb.x = col
                    currentOrb.y = row
                    orbMatrix[row][col] = currentOrb
                    self.addChild(currentOrb)
                }
            }
        }
        //print(self.frame.maxY)
        //print("Orb [0][0] X: \(orbMatrix[0][0]!.position.x)")
        //print("Orb [0][1] X: \(orbMatrix[1][0]!.position.x)")
        //print(GameConstants.OrbWidth)
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
        if colorsUsed.count > 0
        {
            let nextOrb = Orb(color: colorsUsed[Int(arc4random_uniform(UInt32(colorsUsed.count)))])
            orbQueue.append(nextOrb)
            let nextMove = SKAction.move(to: CGPoint(x:self.frame.midX/4, y: GameConstants.OrbHeight/2), duration: 0.5)
            orbQueue.last?.position = CGPoint(x:0 - self.frame.midX/4, y: GameConstants.OrbHeight/2)
            
            let loadingMove = SKAction.move(to: CGPoint(x:self.frame.midX, y:self.frame.minY), duration: 0.5)
            self.addChild(nextOrb)
            orbQueue[0].run(loadingMove)
            nextOrb.run(nextMove)
        }
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
        let orbX = orb.x!
        let orbY = orb.y!
        
        let neighbourOffsets: [[Int]]
        
        if orbY % 2 != 0
        {
            // Checking for an odd row orb
            neighbourOffsets = GameConstants.NeighbourOffsetTable[0]
        }
        else
        {
            // Checking for an even row orb
            neighbourOffsets = GameConstants.NeighbourOffsetTable[1]
        }
        
        for i in 0..<neighbourOffsets.count
//        for i in 0..<GameConstants.NeighbourOffsetTable.count
        {
            let neighbourX = orbX + neighbourOffsets[i][0]
            let neighbourY = orbY + neighbourOffsets[i][1]
//            let neighbourX = orbX + GameConstants.NeighbourOffsetTable[i][0]
//            let neighbourY = orbY + GameConstants.NeighbourOffsetTable[i][1]
            //print(neighbourX)
            //print(neighbourY)
            if (neighbourX >= 0 && neighbourX < orbMatrix[0].count) && (neighbourY >= 0 && neighbourY < orbMatrix.count)
            {
                //print(orbMatrix[neighbourY][neighbourX]?.colour)
                if let neighbour = orbMatrix[neighbourY][neighbourX]
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
                //print("new loop")
                //print(orbsToProcess.count)
//                print("Getting current orb to check")
                let currentOrb = orbsToProcess.removeLast()
                
                if !matchColour || (currentOrb.colour == startingOrb.colour)
                {
                    foundCluster.append(currentOrb)
                    
                    let neighbourOrbs = getOrbNeighbours(currentOrb, matchColour: matchColour)
//                    print("Num neighbours: \(neighbourOrbs.count)")
                    for neighbour in neighbourOrbs
                    {
//
                        //print("neighbour checked: \(neighbour.checkedForCluster)")
                        if !neighbour.checkedForCluster
                        {
//                            print("Adding neighbour to process queue")
                            //print("haah")
                            orbsToProcess.append(neighbour)
                            //print(orbsToProcess.count)
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
    
    private func stopSpawningOrbs(ofColour: String)
    {
        colorsUsed.remove(at: colorsUsed.index(of: ofColour)!)
        
        if reserveOrb != nil
        {
            if reserveOrb!.colour == ofColour
            {
                reserveOrb!.removeFromParent()
                reserveOrb = nil
            }
        }
        
        if orbQueue.last?.colour == ofColour
        {
            orbQueue.removeLast().removeFromParent()
            getNextPlayerOrb()
        }
        
        if orbQueue.first?.colour == ofColour
        {
            orbQueue.removeFirst().removeFromParent()
            getNextPlayerOrb()
        }
    }
    
    private func isColourEliminated(_ colour: String) -> Bool
    {
        for row in orbMatrix
        {
            for orb in row
            {
                if let temp = orb
                {
                    if temp.colour == colour
                    {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    private func onOrbCollision(_ collidingOrb: Orb)
    {
        // Stop orb movement and change its collision category
        collidingOrb.setOrbStuck(true)
        
        let xCenter = collidingOrb.position.x //+ GameConstants.OrbWidth / 4
        let yCenter = self.frame.maxY - collidingOrb.position.y //+ GameConstants.OrbHeight / 70
        
        // Determine how exactly bodyA hit bodyB (from the bottom? from the side?)
        let pos = getGridPosition(xCenter, yCenter, drop: totalDrop)
        collidingOrb.x = Int(pos.x)
        collidingOrb.y = Int(pos.y)
        //print("it begins")
        //print(pos)
        collidingOrb.removeFromParent()
        orbMatrix[collidingOrb.y!][collidingOrb.x!] = collidingOrb
        collidingOrb.position = getOrbCoordinate(collidingOrb.y!, collidingOrb.x!, drop: totalDrop)
        self.addChild(collidingOrb)
        
        let cluster = findOrbCluster(collidingOrb.y!, collidingOrb.x!, matchColour: true, reset: true)
        
        var coloursToCheck = Set<String>()
        coloursToCheck.insert(collidingOrb.colour)
        
        if cluster.count >= 3
        {
            //                print("cluster detected")
            
            for orb in cluster
            {
                orbMatrix[orb.y!][orb.x!] = nil
                orb.removeFromParent()
            }
            
            let floatingClusters = findFloatingClusters()
            
            for cluster in floatingClusters
            {
                for orb in cluster
                {
                    coloursToCheck.insert(orb.colour)
                    orbMatrix[orb.y!][orb.x!] = nil
                    orb.removeFromParent()
                }
            }
            
            if winCheck(orbMatrix: orbMatrix)
            {
                print("You win!")
                moveToNextLevel()
            }
            else
            {
                for colour in coloursToCheck
                {
                    if isColourEliminated(colour)
                    {
                        stopSpawningOrbs(ofColour: colour)
                    }
                }
            }
        }
        lblScore.text = String(format: "Score: %04d", GameVariables.curScore)
        processingPreviousShot = false
        shotsTaken += 1
        
        if loseCheck(orbMatrix: orbMatrix, loseLine: loseLineLocation)
        {
            print("Game over!")
        }
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
            let collidingOrb = bodyA.node as! Orb
//            let stuckOrb = bodyB.node as! Orb
            onOrbCollision(collidingOrb)
        }
        
        if (bodyA.categoryBitMask & GameConstants.CollisionCategories.Orb != 0) && (bodyB.categoryBitMask & GameConstants.CollisionCategories.Barrier != 0)
        {
            print("ORB -> BARRIER")
            onOrbCollision(bodyA.node as! Orb)
        }
    }
    
    override func didMove(to view: SKView)
    {
        dropSize = (self.frame.maxY - 41 - loseLineLocation) / 5
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
        imgBarrier.position = CGPoint(x:self.frame.midX, y:self.frame.midY + self.frame.maxY-41)
        imgBarrier.physicsBody = SKPhysicsBody(rectangleOf: imgBarrier.size) // define boundary of body
        imgBarrier.physicsBody?.isDynamic = true // 2
        imgBarrier.physicsBody?.categoryBitMask = GameConstants.CollisionCategories.Barrier //
        imgBarrier.physicsBody?.contactTestBitMask = GameConstants.CollisionCategories.Orb  // Contact with bullet
        imgBarrier.physicsBody?.collisionBitMask = 0x0 // No bouncing on collision
        self.addChild(imgBarrier)
        
        //Barrier one image created
        print("reserve image created")
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
        
        lblScore.text = String(format: "Score: %04d", GameVariables.curScore)
        lblScore.fontName = "AvenirNext-Bold"
        lblScore.fontSize = 25
        lblScore.fontColor = SKColor.white
        lblScore.position = CGPoint(x: self.frame.minX + 75, y: self.frame.maxY - 25)
        self.addChild(lblScore)
        
        btnPause.size = CGSize(width: 40, height: 40 )
        btnPause.position = CGPoint(x: self.frame.maxX - 20 , y: self.frame.maxY - (btnPause.size.height / 2) )
        btnPause.name = "btnPause"
        btnPause.color = SKColor.white
        let imgPauseBack = SKSpriteNode()
        imgPauseBack.color = SKColor.white
        imgPauseBack.size = CGSize(width: 40, height: 40 )
        imgPauseBack.position = CGPoint(x: self.frame.maxX - 20 , y: self.frame.minY + btnReserve.size.height + (btnPause.size.height / 2) )
        //self.addChild(imgPauseBack)
        self.addChild(btnPause)
        self.addChild(pauseMenu)
        pauseMenu.initPauseMenu()
        
        AudioManager.playBGM(named: level.bgMusicName)
        
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
//        moveToNextLevel()
        if !pauseMenu.isGamePaused
        {
            framesSinceLastTap = 0
            shouldCountFramesSinceLastTap = true
        }
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
        if !pauseMenu.isGamePaused
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
                if node.name == btnReserve.name && !pauseMenu.isGamePaused
                {
                    print("Reserve box tapped")
                    
                    if reserveOrb == nil
                    {
                        print("Sending orb to empty reserve box")
                        reserveOrb = orbQueue.removeFirst()
                        getNextPlayerOrb()
                        let reserveMove = SKAction.move(to: CGPoint(x: size.width - size.width/10, y: size.height/18), duration: 0.5)
                        reserveOrb!.run(reserveMove)
                    }
                    else
                    {
                        print("Swapping with reserve box")
                        let temp = orbQueue[0]
                        orbQueue[0] = reserveOrb!
                        let backMove = SKAction.move(to: CGPoint(x: self.frame.midX, y:self.frame.minY), duration: 0.5)
                        orbQueue[0].run(backMove)
                        reserveOrb = temp
                        let reserveMove = SKAction.move(to: CGPoint(x: size.width - size.width/10, y: size.height/18), duration: 0.5)
                        reserveOrb!.run(reserveMove)
                    }
                    foundOtherEvent = true
                } else if node.name == btnPause.name {
                    pauseMenu.toggleGamePaused()
                    foundOtherEvent = true
                    AudioManager.togglePauseBGM()
                }
                else if node.name == "btnResume"
                {
                    foundOtherEvent = true
                    pauseMenu.toggleGamePaused()
                    AudioManager.togglePauseBGM()
                }
                else if node.name == "btnQuit"
                {
                    foundOtherEvent = true
                    GameVariables.curScore = 0
                    let transition = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.5)
                    let gameScene = TitleScene(size: self.size);
                    self.view?.presentScene(gameScene, transition: transition)
                }
                else if node.name == "btnToggleMute"
                {
                    foundOtherEvent = true
                    AudioManager.toggleMute()
                }
            }
            
            if !pauseMenu.isGamePaused && !foundOtherEvent && !processingPreviousShot
            {
                processingPreviousShot = true
                fire(angle: arrowAnchor.zRotation, orb: orbQueue.removeFirst(), maxX: self.frame.maxX, maxY: self.frame.maxY)
                //print(imgArrow.position)
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
        
        if shotsTaken >= self.level.barrierDropRate
        {
            shotsTaken = 0
            dropper(barrier: imgBarrier, orbMatrix: orbMatrix, dropRate: dropSize)
            totalDrop += dropSize
            
            if loseCheck(orbMatrix: orbMatrix, loseLine: loseLineLocation)
            {
                print("Game Over!")
            }
        }
        
    }
}
