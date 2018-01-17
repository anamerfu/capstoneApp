//
//  MusicHelper.swift
//  capstoneApp
//
//  Created by Laura Douglas on 2018-01-16.
//  Copyright © 2018 Ana Merfu & Laura Douglas. All rights reserved.
//

import Foundation
import AVFoundation

class MusicHelper {
    static let sharedHelper = MusicHelper()
    var audioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        let backgroundSongPath = Bundle.main.path(forResource: "backgroundSong.mp3", ofType:nil)!
        let backgroundSongURL = URL(fileURLWithPath: backgroundSongPath)
    
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundSongURL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.volume = 0.8
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
}
