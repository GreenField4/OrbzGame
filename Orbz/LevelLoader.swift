//
//  LevelLoader.swift
//  Orbz
//
//  Created by Bradley Katz on 2018-03-22.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import Foundation
class LevelLoader
{
    private static let instance = LevelLoader()
    private static let path = Bundle.main.path(forResource: "levels", ofType: "json")
    
    private var levels: Array<Level>
    private var progress: Int
    
    private init()
    {
        progress = 0
        levels = Array<Level>()
    }
    
    public static func loadLevelsFromJSON()
    {
        do
        {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            let decoder = JSONDecoder()
            
            instance.levels = try decoder.decode(Array<Level>.self, from: data)
        }
        catch
        {
            print("\(error)")
        }
    }
    
    public static func getNextLevel() -> Level
    {
        return instance.levels[instance.progress]
    }
    
    public static func isGameBeaten() -> Bool
    {
        instance.progress += 1
        return instance.levels.count == instance.progress
    }
}
