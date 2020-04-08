//
//  MusicService.swift
//  mini-challenge-1
//
//  Created by Baskoro Indrayana on 04/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import UIKit
import AVFoundation

class MusicService {
    
    private var audioPlayer = AVAudioPlayer()
    
    let library: [String: String] = [
        "Lounge Jazz": "lounge-jazz",
        "Lo-Fi": "lofi",
        "Green Nature": "harps-and-guitars",
        "Meditative": "relaxing",
        "Raindrops": "raindrops",
        "Windy Trees": "windy-trees",
    ]
    var titles: [String] { [String](library.keys).sorted() }
    
    func play(title: String) {
        // stop player and undo setup, esp. when existing song is still playing
        stop()
        
        if let filename = library[title] {
            if let songURL = Bundle.main.url(forResource: filename,
                                             withExtension: "mp3") {
                do {
                    audioPlayer = try AVAudioPlayer(
                        contentsOf: songURL)
                    audioPlayer.numberOfLoops = Int.max
                    audioPlayer.play()
                } catch {
                    print("Error playing song: \(error)")
                }
            }
        }
    }
    
    func play(index: Int) { play(title: titles[index]) }
    func pause() { audioPlayer.pause() }
    func stop() { audioPlayer.stop() }
    func togglePlayback() {
        if audioPlayer.isPlaying {
            pause()
        } else {
            audioPlayer.play()
        }
    }
    var isPlaying: Bool { audioPlayer.isPlaying }
    
}
