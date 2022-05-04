//
//  FreespeechVTApp.swift
//  FreespeechVT
//
//  Created by Samuel Oh on 2/15/22.
//

/* Sets the environment of the application */

import SwiftUI

@main
struct FreespeechVTApp: App {
    /*
     App Delegate is directed to AppDelegate struct
     */
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let managedObjectContext = PersistenceController.shared.persistentContainer.viewContext
    
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            // Shown on deployment of the application
            ContentView()
                // Sets environments
                .environment(\.managedObjectContext, managedObjectContext)
                .environmentObject(AudioPlayer())
        }
        .onChange(of: scenePhase) { _ in
            // Change the application on change of life cycle
            PersistenceController.shared.saveContext()
        }
    }
}
