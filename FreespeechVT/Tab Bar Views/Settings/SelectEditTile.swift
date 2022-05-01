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
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Tile.allTilesFetchRequest()) var allTiles: FetchedResults<Tile>
    
    @State private var delete = false
    
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
            Section(header: Text("Delete All Tiles")) {
                Button(action: deleteSwitch) {
                    Text("Delete Tiles")
                        .foregroundColor(Color.red)
                }
            }
        }
        .alert(isPresented: $delete, content: { deleteTiles })
    }
    
    func deleteSwitch() {
        delete = true
    }
    
    var deleteTiles: Alert {
        Alert(title: Text("Delete Tiles!"),
              message: Text("Are you sure you want to delete all tiles?"),
              primaryButton: .default(Text("Cancel")),
              secondaryButton: .destructive(Text("Delete")) {
                  // Dismiss this View and go back
                for tile in allTiles {
                    managedObjectContext.delete(tile)
                }
                      presentationMode.wrappedValue.dismiss()
                }
            )
    }
}
