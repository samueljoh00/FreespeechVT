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
            Home()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            SpeechGrid()
                .tabItem {
                    
                }
        }
    }
}
