//
//  SelectEditTile.swift
//  SelectEditTile
//
//  Created by Andy Cho on 4/26/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import Foundation
import SwiftUI

struct SelectEditTile: View {
    var body: some View {
        Form {
            Section(header: Text("Change Speech Grid")) {
                NavigationLink(destination: ChangeSpeechGrid()) {
                    HStack {
                        Image(systemName: "pencil.circle")
                            .imageScale(.medium)
                            .font(Font.title.weight(.light))
                            .foregroundColor(.blue)
                        Text("Edit Speech Grid Tiles")
                    }
                }
            }
            Section(header: Text("Change Floating Word Dock")) {
                NavigationLink(destination: ChangeWordDock())  {
                    HStack {
                        Image(systemName: "pencil.circle")
                            .imageScale(.medium)
                            .font(Font.title.weight(.light))
                            .foregroundColor(.blue)
                        Text("Edit Word Dock Tiles")
                    }
                }
            }
        }
    }
}
