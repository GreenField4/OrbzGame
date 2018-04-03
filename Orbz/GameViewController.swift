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
        
        let titleScene = TitleScene()
        titleScene.scaleMode = .resizeFill
        
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        skView.showsNodeCount = false
        skView.showsFPS = false
        skView.showsPhysics = false
        
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
