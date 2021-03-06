//
//  AudioManager.swift
//  Orbz
//
//  Created by Bradley Katz on 2018-03-29.
//  Copyright © 2018 Andrew Greenfield. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit

class AudioManager
{
    private static let instance = AudioManager()
    private var bgmPlayer: AVAudioPlayer?
    private var urlCurrentBGM: URL?
    private var isPaused = false
    
    private init() {}
    
    public static func toggleMute()
    {
        if GameVariables.toggleMute
        {
            enableBGM()
        }
        else
        {
            stopBGM()
        }
        
        GameVariables.toggleMute = !GameVariables.toggleMute
    }
    
    private static func enableBGM()
    {
        do
        {
            instance.bgmPlayer = try AVAudioPlayer(contentsOf: instance.urlCurrentBGM!)
            
            instance.bgmPlayer!.numberOfLoops = -1
            
            if (!instance.isPaused)
            {
                instance.bgmPlayer!.play()
            }
        }
        catch
        {
            print("\(error)")
        }
    }
    
    public static func playBGM(named: String, loop: Bool = true)
    {
        let path = Bundle.main.path(forResource: "Sounds/\(named).mp3", ofType: nil)
        instance.urlCurrentBGM = URL(fileURLWithPath: path!)
        
        do
        {
            if instance.bgmPlayer != nil
            {
                stopBGM()
            }
            
            if !GameVariables.toggleMute
            {
                instance.bgmPlayer = try AVAudioPlayer(contentsOf: instance.urlCurrentBGM!)
                
                if loop
                {
                    instance.bgmPlayer!.numberOfLoops = -1
                }
                
                instance.bgmPlayer!.play()
            }
        }
        catch
        {
            print("\(error)")
        }
    }
    
    public static func stopBGM()
    {
        if !GameVariables.toggleMute && instance.bgmPlayer != nil
        {
            instance.bgmPlayer!.stop()
            instance.bgmPlayer = nil
        }
    }
    
    public static func togglePauseBGM()
    {
        if !GameVariables.toggleMute && instance.bgmPlayer != nil
        {
            if instance.bgmPlayer!.isPlaying
            {
                instance.bgmPlayer!.pause()
                instance.isPaused = true
            }
            else
            {
                instance.bgmPlayer!.play()
                instance.isPaused = false
            }
        }
    }
    
    public static func playSFX(named: String, waitForCompletion: Bool = false) -> SKAction?
    {
        if !GameVariables.toggleMute
        {
            return SKAction.playSoundFileNamed("Sounds/Sound Effects/\(named).mp3", waitForCompletion: waitForCompletion)
        }
        else
        {
            return nil
        }
    }
}
