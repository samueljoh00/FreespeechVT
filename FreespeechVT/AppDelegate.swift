//
//  AppDelegate.swift
//  AppDelegate
//
//  Created by Andy Cho on 2/22/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        getPermissionForVoiceRecording()
        createTilesDatabse()
        
        return true
    }
}
