//
//  AudioPlayer.swift
//  FreespeechVT
//
//  Created by Chaitanya Gupta on 4/18/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

/* Audio player class */

final class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var isPlaying = false
    
    var audioPlayer: AVAudioPlayer!
    
    // Stores audio player into data
    func createAudioPlayer(audioData: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer!.prepareToPlay()
        } catch {
            print("Unable to create AVAudioPlayer!")
        }
    }
    
    // Starts the audioi player
    func startAudioPlayer() {
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Unable to route audio to the built-in speaker!")
        }
        audioPlayer.delegate = self
        
        audioPlayer.play()
        isPlaying = true
    }
    
    func pauseAudioPlayer() {
        audioPlayer.pause()
        isPlaying = false
    }
    
    func stopAudioPlayer() {
        if let player = audioPlayer {
            player.stop()
            isPlaying = false
        }
    }
    
    //checks when audio player finished playing
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
}



