//
//  ContentView.swift
//  FreespeechVT
//
//  Created by Samuel Oh on 2/15/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            SpeechGrid()
                .tabItem {
                    Image(systemName: "square.grid.3x2.fill")
                    Text("Tiles")
                }
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            References()
                .tabItem {
                    Image(systemName: "menucard.fill")
                    Text("References")
                }
        }
    }
}
