//
//  VoiceRecording.swift
//  FreespeechVT
//
//  Created by Chaitanya Gupta on 4/18/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

// Global Variables
var audioSession:   AVAudioSession!
var audioRecorder:  AVAudioRecorder!

/*
******************************************
MARK: - Get Permission for Voice Recording
******************************************
*/
public func getPermissionForVoiceRecording() {
    
    // Create the shared audio session instance
    audioSession = AVAudioSession.sharedInstance()
    
    do {
        // Set audio session category to record and play back audio
        try audioSession.setCategory(.playAndRecord, mode: .default)
        
        // Activate the audio session
        try audioSession.setActive(true)
        
        // Request permission to record user's voice
        audioSession.requestRecordPermission() { allowed in
            DispatchQueue.main.async {
                if allowed {
                    // Permission is recorded in the Settings app on user's device
                } else {
                    // Permission is recorded in the Settings app on user's device
                }
            }
        }
    } catch {
        print("Setting category or getting permission failed!")
    }
}

