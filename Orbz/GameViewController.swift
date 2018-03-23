//
//  GameViewController.swift
//  Orbz
//
//  Created by Andrew Greenfield on 2018-03-22.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        // Test level loading
        LevelLoader.loadLevelsFromJSON()
        let level = LevelLoader.getNextLevel()
        print("BG Texture: \(level.bgTextureName)")
        print("BG Music: \(level.bgMusicName)")
        
        for row in level.orbMatrix
        {
            for orb in row
            {
                print("Orb Color: \(orb.color)")
        
            }
        }
        
        print("")
        
        let level2 = LevelLoader.getNextLevel()
        print("BG Texture: \(level2.bgTextureName)")
        print("BG Music: \(level2.bgMusicName)")
        
        for row in level2.orbMatrix
        {
            for orb in row
            {
                print("Orb Color: \(orb.color)")
                
            }
        }
        */
        let titleScene = TitleScene()
        titleScene.scaleMode = .resizeFill
        
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        skView.showsNodeCount = true
        skView.showsFPS = true
        
        skView.presentScene(titleScene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
