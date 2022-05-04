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

var audioSession:   AVAudioSession!
var audioRecorder:  AVAudioRecorder!

/* Prompts for user permission of voice recording*/
public func getPermissionForVoiceRecording() {
    
    audioSession = AVAudioSession.sharedInstance()
    
    do {
        try audioSession.setCategory(.playAndRecord, mode: .default)
        
        try audioSession.setActive(true)
        
        audioSession.requestRecordPermission() { allowed in
            DispatchQueue.main.async {
                if allowed {
                } else {
                }
            }
        }
    } catch {
        print("Setting category or getting permission failed!")
    }
}

