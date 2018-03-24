//
//  GameConstants.swift
//  Orbz
//
//  Created by Bradley Katz on 2018-03-23.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import Foundation
import SpriteKit

struct GameConstants
{
    private init() {}
    
    private static let redOrbTexture = UIImage(named: "sphere_red")!
    private static let blueOrbTexture = UIImage(named: "sphere_blue")!
    private static let greenOrbTexture = UIImage(named: "sphere_green")!
    private static let yellowOrbTexture = UIImage(named: "sphere_golden")!
    private static let purpleOrbTexture = UIImage(named: "sphere_purple")!
    private static let orangeOrbTexture = UIImage(named: "sphere_orange")!
    private static let pinkOrbTexture = UIImage(named: "sphere_pink")!
    
    public static let orbTextureAtlas = SKTextureAtlas(dictionary: ["red":redOrbTexture, "blue":blueOrbTexture, "green":greenOrbTexture, "yellow":yellowOrbTexture, "purple":purpleOrbTexture, "orange":orangeOrbTexture, "pink":pinkOrbTexture])
    
    public static let OrbWidth = redOrbTexture.size.width / 2
    public static let OrbHeight = redOrbTexture.size.height / 2
    public static let RowOffset = CGFloat(2)
    public static let RowHeight = CGFloat(0)
}