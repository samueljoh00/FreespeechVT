//
//  FreespeechVTApp.swift
//  FreespeechVT
//
//  Created by Samuel Oh on 2/15/22.
//

import SwiftUI

@main
struct FreespeechVTApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
