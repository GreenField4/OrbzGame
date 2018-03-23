//
//  Level.swift
//  Orbz
//
//  Created by Bradley Katz on 2018-03-22.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import Foundation

class Level: Codable
{
    public let bgTextureName: String
    public let bgMusicName: String
    public let orbMatrix: Array<Array<Orb>>
}
