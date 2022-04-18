//
//  FreespeechVTApp.swift
//  FreespeechVT
//
//  Created by Samuel Oh on 2/15/22.
//

import SwiftUI

@main
struct FreespeechVTApp: App {
    /*
     Use the UIApplicationDelegateAdaptor property wrapper to direct SwiftUI
     to use the AppDelegate class for the application delegate.
     */
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // ❎ Get object reference of CoreData managedObjectContext from the persistent container
    let managedObjectContext = PersistenceController.shared.persistentContainer.viewContext
    
    /*
     @Environment property wrapper for SwiftUI's pre-defined key scenePhase is declared to
     monitor changes of app's life cycle states such as active, inactive, or background.
     The \. indicates that we access scenePhase by its object reference, not by its value.
     */
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            // ContentView is the root view to be shown first upon app launch
            ContentView()
                /*
                 Inject managedObjectContext into ContentView as an environment variable
                 so that it can be referenced in any SwiftUI view as
                    @Environment(\.managedObjectContext) var managedObjectContext
                 */
                .environment(\.managedObjectContext, managedObjectContext)
                .environmentObject(AudioPlayer())
        }
        .onChange(of: scenePhase) { _ in
            /*
             Save database changes if any whenever app life cycle state
             changes. The saveContext() method is given in Persistence.
             */
            PersistenceController.shared.saveContext()
        }
    }
}
