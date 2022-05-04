//
//  ChangeSpeechGrid.swift
//  ChangeSpeechGrid
//
//  Created by Andy Cho on 4/26/22.
//  Copyright © 2022 FreespeechVT. All rights reserved.
//

import Foundation
import SwiftUI

/* List of speech grid tiles to edit */

struct ChangeSpeechGrid: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: Tile.allTilesFetchRequest()) var allTiles: FetchedResults<Tile>
    
    var body: some View {
        List {
            ForEach(allTiles) { aTile in
                if (!aTile.frequency) {
                    NavigationLink(destination: EditTile(currTile: aTile)) {
                        TileItem(tile: aTile)
                    }
                }
            }
        }
    }
}
