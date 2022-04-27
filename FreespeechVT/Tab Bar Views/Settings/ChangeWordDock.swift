//
//  ChangeWordDock.swift
//  ChangeWordDock
//
//  Created by Andy Cho on 4/26/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import Foundation
import SwiftUI

struct ChangeWordDock: View {
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❎ CoreData FetchRequest returning all music album entities in the database
    @FetchRequest(fetchRequest: Tile.allTilesFetchRequest()) var allTiles: FetchedResults<Tile>
    
    var body: some View {
        List {
            ForEach(allTiles) { aTile in
                if (aTile.frequency) {
                    NavigationLink(destination: EditTile(currTile: aTile)) {
                        TileItem(tile: aTile)
                    }
                }
            }
        }
    }
}
